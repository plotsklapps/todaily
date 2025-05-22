import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/logic/firebase_service.dart';
import 'package:todaily/screens/signin_screen.dart';
import 'package:todaily/state/loading_signal.dart';
import 'package:todaily/state/regex_signal.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() {
    return ForgotPasswordScreenState();
  }
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TODAILY',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Reset Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
                textAlign: TextAlign.center,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Email required';
                  }
                  if (!sEmailRegexp.value.hasMatch(value)) {
                    return 'Email invalid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      // Navigate to SignInScreen
                      sSelectedSignInOption.value = 'Sign In';
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return const SignInScreen();
                          },
                        ),
                      );
                    },
                    child: const Text('Back to sign in'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      // Validate the form
                      if (_formKey.currentState?.validate() ?? false) {
                        // Reset the password
                        await _firebaseService.passwordReset(
                          context: context,
                          email: _emailController.text,
                        );
                      }
                    },
                    child: sLoading.watch(context)
                        ? const SizedBox(
                            width: 24,
                            child: LinearProgressIndicator(),
                          )
                        : const Text('Reset Password'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
