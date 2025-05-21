import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/firebase/firebase_service.dart';
import 'package:todaily/logic/modal_logic.dart';
import 'package:todaily/modals/verifyemail_modal.dart';
import 'package:todaily/state/loading_signal.dart';
import 'package:todaily/state/regex_signal.dart';

class SignUpContents extends StatefulWidget {
  const SignUpContents({super.key});

  @override
  State<SignUpContents> createState() {
    return _SignUpContentsState();
  }
}

class _SignUpContentsState extends State<SignUpContents> {
  final FirebaseService _firebaseService = FirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            controller: _displayNameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(hintText: 'Username'),
            textAlign: TextAlign.center,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Username required';
              }
              return null;
            },
          ),
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
          TextFormField(
            controller: _confirmPasswordController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: 'Confirm Password'),
            textAlign: TextAlign.center,
            obscureText: true,
            enableSuggestions: false,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Confirm password required';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
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
                    // Show the VerifyEmailModal
                    showModalSheet(
                      context: context,
                      child: const VerifyEmailModal(),
                    );
                  },
                  child: const Text(
                    'You will receive an email to verify your account.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    // Validate the form
                    if (_formKey.currentState?.validate() ?? false) {
                      // Sign up the user
                      await _firebaseService.signUp(
                        context: context,
                        displayName: _displayNameController.text,
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
                      : const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
