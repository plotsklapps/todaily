import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todaily/logic/firebase_service.dart';
import 'package:todaily/logic/toast_logic.dart'; // Assuming you have ToastService

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() {
    return _VerificationScreenState();
  }
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isSendingVerification = false;

  Future<void> _sendVerificationEmail() async {
    setState(() {
      _isSendingVerification = true;
    });
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        // Show a success message
        ToastService.showSuccessToast(
          title: 'Verification Email Sent',
          description: 'Please check your inbox to verify your email.',
        );
      }
    } on Exception catch (e) {
      // Show an error message
      ToastService.showErrorToast(
        title: 'Error sending verification email',
        description: '$e',
      );
    } finally {
      setState(() {
        _isSendingVerification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _firebaseService.signOut(context: context);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.email,
                size: 80,
                color: Colors.blue, // Or your theme's color
              ),
              const SizedBox(height: 16),
              const Text(
                'Please verify your email address.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'A verification link has been sent to your email. Click the link to activate your account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSendingVerification
                    ? null
                    : _sendVerificationEmail,
                child: _isSendingVerification
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Resend Verification Email'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Optionally, guide the user back to sign in if needed,
                  // or rely on the auth state change to navigate.
                  // For now, signing out and letting LoadingScreen handle it is sufficient.
                },
                child: const Text('Signed in with a different account?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
