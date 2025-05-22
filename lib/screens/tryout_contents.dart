import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/logic/firebase_service.dart';
import 'package:todaily/logic/modal_logic.dart';
import 'package:todaily/modals/tryout_modal.dart';
import 'package:todaily/state/loading_signal.dart';

class TryOutContents extends StatefulWidget {
  const TryOutContents({super.key});

  @override
  State<TryOutContents> createState() {
    return _TryOutContentsState();
  }
}

class _TryOutContentsState extends State<TryOutContents> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Show the TryoutModal
                    showModalSheet(
                      context: context,
                      child: const TryoutModal(),
                    );
                  },
                  child: const Text(
                    'Try out the app. Your anonymous account will be valid for '
                    '30 days.',
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
                      // Sign in anonymously
                      await firebaseService.signInAnonymously(
                        context: context,
                        displayName: _displayNameController.text,
                      );
                    }
                  },
                  child: sLoading.watch(context)
                      ? const SizedBox(
                          width: 24,
                          child: LinearProgressIndicator(),
                        )
                      : const Text('Try Out'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
