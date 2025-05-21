import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:todaily/firebase/firestore_service.dart';
import 'package:todaily/screens/main_screen.dart';
import 'package:todaily/screens/signin_screen.dart';
import 'package:todaily/state/loading_signal.dart';
import 'package:todaily/state/useranon_signal.dart';
import 'package:todaily/state/useremail_signal.dart';
import 'package:todaily/state/username_signal.dart';
import 'package:todaily/state/userverified_signal.dart';
import 'package:todaily/theme/themecolors_carousel.dart';
import 'package:todaily/theme/themefont_carousel.dart';
import 'package:todaily/theme/thememode_carousel.dart';
import 'package:todaily/toast.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final Logger _logger = Logger();

  /////////////////////////////////////////////////////////////////////////////
  Future<void> signInAnonymously({
    required BuildContext context,
    required String displayName,
  }) async {
    sLoading.value = true;

    try {
      // Sign in the user anonymously and fetch the UserCredential
      final UserCredential userCredential = await _auth.signInAnonymously();

      // User is now anonymous. This value is used throughout the app for
      // checking if the user should have certain rights or not
      sAnonUser.value = true;

      // Add the user to Firestore, using the UserCredential's uid
      await _firestoreService.addUserToFirestore(user: userCredential.user);

      // Update the user's display name in Firebase
      await userCredential.user!.updateDisplayName(displayName.trim());

      // Update the user displayName in it's Signal
      sUsername.value = displayName.trim();

      // Log the sign in event, show a toast to the user and log the success
      await FirebaseAnalytics.instance.logLogin(loginMethod: 'anonymous');
      showSuccessToast(
        title: 'Anonymous sign in successful!',
        description:
            'Your account is valid for 30 days. Please consider signing '
            'up to save your data.',
      );
      _logger.i('Anonymous sign in successful: ${userCredential.user!.uid}');

      // Navigate to MainScreen
      if (context.mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) {
              return const MainScreen();
            },
          ),
        );
      }
    } on FirebaseAuthException catch (error, stackTrace) {
      // Show a toast to the user and log the error
      showErrorToast(title: 'Error signing up!', description: '$error');
      _logger.e('Error signing up: $error, $stackTrace');

      // Something went wrong, reset all Signals to default values
      sAnonUser.value = false;
      sUsername.value = 'Anonymous';
    } finally {
      sLoading.value = false;
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String displayName,
  }) async {
    sLoading.value = true;

    try {
      // Fetch the current user (if any)
      final User? currentUser = _auth.currentUser;

      UserCredential? userCredential;

      // If the user is not null but anonymous, run this block
      if (currentUser != null && currentUser.isAnonymous) {
        // User is not null, but anonymous
        sAnonUser.value = true;

        // Create an AuthCredential for the email/password
        final AuthCredential credential = EmailAuthProvider.credential(
          email: email.trim(),
          password: password.trim(),
        );

        // Link the credential to the anonymous user
        userCredential = await currentUser.linkWithCredential(credential);

        // User is not anonymous anymore
        sAnonUser.value = false;
      } else {
        // Create a new user from scratch and fetch the UserCredential
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      }

      // Add the new user to Firestore, using the UserCredential's uid
      await FirestoreService().addUserToFirestore(user: userCredential.user);

      // Update the user's display name in Firebase
      await userCredential.user!.updateDisplayName(displayName.trim());

      // Update user's display name in it's Signal
      sUsername.value = displayName.trim();

      // Send user a verification email
      await userCredential.user!.sendEmailVerification();

      // Log the sign up event, show a toast to the user and log the success
      await FirebaseAnalytics.instance.logSignUp(signUpMethod: 'email');
      showSuccessToast(
        title: 'Verification email sent!',
        description:
            'Please check your email to verify your account. '
            'Consider checking your spam folder as well.',
      );
      _logger.i('Sign up successful: ${userCredential.user!.uid}');

      if (context.mounted) {
        // Make sure the right content is shown
        sSelectedSignInOption.value = 'SignIn';

        // Navigate to SignInScreen
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) {
              return const SignInScreen();
            },
          ),
        );
      }
    } on FirebaseAuthException catch (error, stackTrace) {
      // Show a toast to the user and log the error
      showErrorToast(title: 'Error signing up!', description: '$error');
      _logger.e('Error signing up: $error, $stackTrace');
    } finally {
      sLoading.value = false;
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    sLoading.value = true;

    try {
      // Sign in the user and fetch the UserCredential
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      // If the email is NOT verified, run this block
      if (!userCredential.user!.emailVerified) {
        // Show a toast to the user and log the warning
        showWarningToast(
          title: 'Email not verified!',
          description: 'Please verify your email before signing in.',
        );
        _logger.w('Error signing in: Email not verified!');

        // Sign out the user
        await _auth.signOut();

        return;
      }

      // Fetch user data from Firestore
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      if (userDoc.exists) {
        final Map<String, dynamic> userData = userDoc.data()!;

        // Update the user data Signals
        sAnonUser.value = userData['isAnonymous'] as bool? ?? false;
        sUserVerified.value = userData['isVerified'] as bool? ?? false;
        sUseremail.value =
            userData['email'] as String? ?? 'anonymous@email.com';
        sUsername.value = userData['displayName'] as String? ?? 'Anonymous';

        // Log the sign in event, show a toast to the user and log the success
        await FirebaseAnalytics.instance.logLogin(loginMethod: 'email');
        showSuccessToast(
          title: 'Sign in successful!',
          description:
              'Welcome '
              'back, ${sUsername.value}!',
        );
        _logger.i('Sign in successful: ${userCredential.user!.uid}');

        // Navigate to LoadingScreen
        if (context.mounted) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute<Widget>(
              builder: (BuildContext context) {
                return const MainScreen();
              },
            ),
          );
        }
      }
    } on FirebaseAuthException catch (error, stackTrace) {
      // Show a toast to the user and log the error
      showErrorToast(title: 'Error signing in!', description: '$error');
      _logger.e('Error signing in: $error, $stackTrace');
    } finally {
      sLoading.value = false;
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> signOut({required BuildContext context}) async {
    try {
      sLoading.value = true;
      // Sign out the user
      await _auth.signOut();

      // Clear the Signals and set them to default values
      sAnonUser.value = true;
      sSelectedSignInOption.value = 'SignIn';
      sUsername.value = 'Anonymous';
      sFlexScheme.value = FlexScheme.blackWhite;
      sThemeMode.value = ThemeMode.light;
      sFont.value = GoogleFonts.questrial().fontFamily!;

      // Log the event, show a toast to the user and log the success
      await FirebaseAnalytics.instance.logEvent(name: 'sign_out');
      showSuccessToast(
        title: 'Sign out successful!',
        description: 'You have been signed out',
      );
      _logger.i('Sign out successful!');

      // Navigate to SignInScreen
      if (context.mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) {
              return const SignInScreen();
            },
          ),
        );
      }
    } on FirebaseAuthException catch (error, stackTrace) {
      // Show a toast to the user and log the error
      showErrorToast(title: 'Error signing out!', description: '$error');
      _logger.e('Error signing out: $error, $stackTrace');
    } finally {
      sLoading.value = false;
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> passwordReset({
    required BuildContext context,
    required String email,
  }) async {
    sLoading.value = true;

    try {
      // Send password reset email
      await _auth.sendPasswordResetEmail(email: email.trim());

      // Log the event, show a toast to the user and log the success
      await FirebaseAnalytics.instance.logEvent(
        name: 'password_reset',
        parameters: <String, Object>{'email': email.trim()},
      );
      showSuccessToast(
        title: 'Password reset email sent!',
        description:
            'Please check your email to reset your password. '
            'Consider checking your spam folder as well.',
      );
      _logger.i('Password reset email sent: $email');

      // Navigate to the SignInScreen
      if (context.mounted) {
        // Make sure the right content is shown
        sSelectedSignInOption.value = 'SignIn';

        // Navigate to SignInScreen
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) {
              return const SignInScreen();
            },
          ),
        );
      }
    } on FirebaseAuthException catch (error, stackTrace) {
      // Show a toast to the user and log the error
      showErrorToast(
        title: 'Error sending password reset email!',
        description: '$error',
      );
      _logger.e('Error sending password reset email: $error, $stackTrace');
    } finally {
      sLoading.value = false;
    }
  }
}
