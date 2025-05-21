import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/firebase/firebase_service.dart';
import 'package:todaily/screens/password_screen.dart';
import 'package:todaily/state/loading_signal.dart';
import 'package:todaily/state/regex_signal.dart';

class SignInContents extends StatefulWidget {
  const SignInContents({super.key});

  @override
  State<SignInContents> createState() {
    return _SignInContentsState();
  }
}

class _SignInContentsState extends State<SignInContents> {
  final FirebaseService _firebaseService = FirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
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
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: 'Password'),
            textAlign: TextAlign.center,
            obscureText: true,
            enableSuggestions: false,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Password required';
              }
              if (value.length < 6) {
                return 'Password invalid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Navigate to ForgotPasswordScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) {
                          return const ForgotPasswordScreen();
                        },
                      ),
                    );
                  },
                  child: const Text('Forgot password'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    // Validate the form
                    if (_formKey.currentState?.validate() ?? false) {
                      // Sign in the user
                      await _firebaseService.signIn(
                        context: context,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    }
                  },
                  child: sLoading.watch(context)
                      ? const SizedBox(
                          width: 24,
                          child: LinearProgressIndicator(),
                        )
                      : const Text('Sign In'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
