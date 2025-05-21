import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todaily/theme/flex_theme.dart';

class VerifyEmailModal extends StatelessWidget {
  const VerifyEmailModal({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        physics: const BouncingScrollPhysics(),
        dragDevices: <PointerDeviceKind>{
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Verify Email'),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'You will receive an email from TODAILY. with a link to verify '
                'your email address.',
                textAlign: TextAlign.center,
              ),
              Text(
                'Please consider checking your spam folder if you do not see '
                'the email in your inbox.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cThemeData.value.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Pop the bottomsheet.
                        Navigator.pop(context);
                      },
                      child: const Text('Understood'),
                    ),
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
