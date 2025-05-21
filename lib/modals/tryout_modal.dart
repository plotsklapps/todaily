import 'dart:ui';

import 'package:flutter/material.dart';

class TryoutModal extends StatelessWidget {
  const TryoutModal({super.key});

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
              const Text('Try GYMPLY.'),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                "You're just one tap away from trying GYMPLY.\nDesigned as a"
                ' Progressive Web App, GYMPLY works on all devices and '
                'platforms. But since the app currently works in your browser, '
                "we can't be sure your data is stored securely.\nSince we "
                'do not store anything without your consent, we will automatically '
                'delete all your data after 30 days. If you want to to '
                "keep your workouts, please create an account, when you're ready.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Pop the bottomsheet
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
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
