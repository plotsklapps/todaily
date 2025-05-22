import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todaily/screens/main_screen.dart';
import 'package:todaily/screens/signin_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    await Future<void>.delayed(Duration.zero);

    if (FirebaseAuth.instance.currentUser != null) {
      // User is logged in, navigate to MainScreen
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
    } else {
      // User is not logged in, navigate to SignInScreen
      if (mounted) {
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
