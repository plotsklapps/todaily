import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todaily/state/loading_signal.dart';
import 'package:todaily/state/useranon_signal.dart';
import 'package:todaily/state/useremail_signal.dart';
import 'package:todaily/state/username_signal.dart';
import 'package:todaily/state/userverified_signal.dart';
import 'package:todaily/theme/themecolors_carousel.dart';
import 'package:todaily/theme/themefont_carousel.dart';
import 'package:todaily/theme/thememode_carousel.dart';
import 'package:todaily/toast.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  /////////////////////////////////////////////////////////////////////////////
  Future<void> addUserToFirestore({required User? user}) async {
    if (user != null) {
      sLoading.value = true;

      try {
        // Add a user to the users collection under their UID and set fields
        // with personal information
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(<String, dynamic>{
              'isAnonymous': user.isAnonymous,
              'email': user.email ?? 'anon@email.com',
              'isVerified': user.emailVerified,
              'displayName': sUsername.value,
              'createdAt': user.metadata.creationTime,
              'lastSeen': user.metadata.lastSignInTime ?? DateTime.now(),
            }, SetOptions(merge: true));

        // Log the success
        _logger.i('User added to Firestore successfully');
      } on FirebaseAuthException catch (e) {
        // Show a toast to the user and log the error
        showErrorToast(
          title: 'Error adding user to Firestore!',
          description: '$e',
        );
        _logger.e('Error adding user to Firestore: $e');
      } finally {
        sLoading.value = false;
      }
    } else {
      // Show a toast to the user and log the error
      showErrorToast(
        title: 'Error adding user to Firestore!',
        description: 'User is null. Try restarting the app.',
      );
      _logger.e('User is null');
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> loadUserData({required User? user}) async {
    if (user != null) {
      sLoading.value = true;

      try {
        // Get the user document by the user's UID
        final DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        // Parse the data to a Map<String, dynamic> object
        final Map<String, dynamic>? data = userDoc.data();
        if (data != null) {
          // Fill the Signals with the data from the document
          if (data.containsKey('isAnonymous')) {
            sAnonUser.value = data['isAnonymous'] as bool;
          }
          if (data.containsKey('email')) {
            sUseremail.value = data['email'] as String;
          }
          if (data.containsKey('isVerified')) {
            sUserVerified.value = data['isVerified'] as bool;
          }
          if (data.containsKey('displayName')) {
            sUsername.value = data['displayName'] as String;
          }
        } else {
          // Show a toast to the user and log the warning
          showWarningToast(
            title: 'No user data found!',
            description: 'You have not saved any user data yet.',
          );
          _logger.w('No user found');
        }
        // Show a toast to the user and log the success
        showSuccessToast(
          title: 'User data loaded!',
          description: 'Successfully retrieved user data from the cloud.',
        );
        _logger.i('User loaded successfully');
      } on FirebaseException catch (e) {
        // Show a toast to the user and log the error
        showErrorToast(title: 'Error loading user data!', description: '$e');
        _logger.e('Error loading user data: $e');
      } finally {
        sLoading.value = false;
      }
    } else {
      // Show a toast to the user and log the error}
      showErrorToast(
        title: 'Error loading user data!',
        description: 'User is null.',
      );
      _logger.e('User is null');
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> updateUser({
    required BuildContext context,
    required User? user,
  }) async {
    if (user != null) {
      sLoading.value = true;

      try {
        // Update user's information to the users collection under their UID
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(<String, dynamic>{
              'isAnonymous': user.isAnonymous,
              'email': user.email,
              'isVerified': user.emailVerified,
              'displayName': sUsername.value,
              'createdAt': user.metadata.creationTime,
              'lastSeen': DateTime.now(),
            }, SetOptions(merge: true));

        // Show a toast to the user and log the success
        showSuccessToast(
          title: 'User data saved!',
          description: 'Data successfully transferred to the cloud.',
        );
        _logger.i('User data saved successfully');

        // Pop the bottomsheet
        if (context.mounted) {
          Navigator.pop(context);
        }
      } on FirebaseException catch (e) {
        // Show a toast to the user and log the error
        showErrorToast(title: 'Error updating user data!', description: '$e');
        _logger.e('Error updating user data: $e');
      } finally {
        sLoading.value = false;
      }
    } else {
      // Show a toast to the user and log the error
      showErrorToast(
        title: 'Error saving workout!',
        description: 'User is null. Try restarting the app.',
      );
      _logger.e('User is null');
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> addSettings({
    required BuildContext context,
    required User? user,
  }) async {
    if (user != null) {
      sLoading.value = true;

      try {
        // Create a document reference under the user's UID and the settings
        // collection
        final DocumentReference<Map<String, dynamic>> settingsDoc = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('settings')
            .doc('settings');

        // Set the data of the document with the personal settings from their
        // respective Signals. SetOptions(merge: true) is used to merge the data
        // with the existing data if the document already exists or to create a
        // new document if it doesn't exist.
        await settingsDoc.set(<String, dynamic>{
          'themeMode': sThemeMode.value.toString(),
          'themeColors': sFlexScheme.value.name,
          'themeFont': sFont.value,
        }, SetOptions(merge: true));

        // Show a toast to the user and log the success
        showSuccessToast(
          title: 'Settings saved!',
          description: 'Data successfully transferred to the cloud.',
        );
        _logger.i('Settings saved successfully');

        // Pop the bottomsheet
        if (context.mounted) {
          Navigator.pop(context);
        }
      } on FirebaseException catch (e) {
        // Show a toast to the user and log the error
        showErrorToast(title: 'Error saving settings!', description: '$e');
        _logger.e('Error saving settings: $e');
      } finally {
        sLoading.value = false;
      }
    } else {
      // Show a toast to the user and log the error
      showErrorToast(
        title: 'Error saving settings!',
        description: 'User is null. Try restarting the app.',
      );
      _logger.e('User is null');
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<void> loadUserSettings({required User? user}) async {
    if (user != null) {
      sLoading.value = true;

      try {
        // Get the settings document under the user's UID and the settings doc
        final DocumentSnapshot<Map<String, dynamic>> settingsDoc =
            await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('settings')
                .doc('settings')
                .get();

        if (settingsDoc.exists) {
          // Parse the data to a Map<String, dynamic> Object
          final Map<String, dynamic>? data = settingsDoc.data();
          if (data != null) {
            // Set 'sThemeMode' to the 'themeMode' value from 'data' or default
            // to 'ThemeMode.system'
            if (data.containsKey('themeMode')) {
              sThemeMode.value = ThemeMode.values.firstWhere(
                (ThemeMode e) {
                  return e.toString() == data['themeMode'] as String;
                },
                orElse: () {
                  return ThemeMode.system;
                },
              );
            }
            // Set 'sFlexScheme' to the 'themeColors' value from 'data' or
            // default to 'FlexScheme.blackWhite'
            if (data.containsKey('themeColors')) {
              final String themeColorName = data['themeColors'] as String;
              sFlexScheme.value = FlexScheme.values.firstWhere(
                (FlexScheme scheme) {
                  return scheme.name == themeColorName;
                },
                orElse: () {
                  return FlexScheme.blackWhite;
                },
              );
            }
            // Set 'sAppFont' to the 'themeFont' value from 'data' or default to
            // 'AppFont.teko'
            if (data.containsKey('themeFont')) {
              final String themeFontName = data['themeFont'] as String;
              sFont.value = themeFontName;
            }
          }

          // Log the success
          _logger.i('Settings loaded successfully');
        } else {
          // Show a toast to the user and log the warning
          showWarningToast(
            title: 'No settings found!',
            description: 'You have not saved any settings yet.',
          );
          _logger.w('No settings found');
        }
      } on FirebaseException catch (e) {
        // Show a toast to the user and log the error
        showErrorToast(title: 'Error loading settings!', description: '$e');
        _logger.e('Error loading settings: $e');
      } finally {
        sLoading.value = false;
      }
    } else {
      // Show a toast to the user and log the error
      showErrorToast(
        title: 'Error loading settings!',
        description: 'User is null. Try restarting the app.',
      );
      _logger.e('User is null');
    }
  }
}
