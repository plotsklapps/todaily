import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todaily/logic/firestore_service.dart';
import 'package:todaily/logic/toast_logic.dart';
import 'package:todaily/screens/main_screen.dart';
import 'package:todaily/screens/signin_screen.dart';
import 'package:todaily/screens/verification_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<User?>? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      _checkUserAuthentication(user: user);
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkUserAuthentication({required User? user}) async {
    if (user != null && user.emailVerified) {
      // Load user data.
      await _firestoreService.loadUserData(user: user);
      // Navigate to MainScreen.
      if (mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) {
              return const MainScreen();
            },
          ),
        );
      }
    } else if (user != null && !user.emailVerified) {
      ToastService.showWarningToast(
        title: 'Email not verified',
        description:
            'Please check your email to continue. Consider checking your spam folder.',
      );
      // Navigate to SignInScreen.
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) {
            return const VerificationScreen();
          },
        ),
      );
    } else {
      // Navigate to SignInScreen.
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) {
            return const SignInScreen();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 64),
          child: LinearProgressIndicator(),
        ),
      ),
    );
  }
}
