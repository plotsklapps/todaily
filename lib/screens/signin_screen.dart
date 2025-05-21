import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/screens/signin_contents.dart';
import 'package:todaily/screens/signup_contents.dart';
import 'package:todaily/screens/tryout_contents.dart';

final Signal<String> sSelectedSignInOption = Signal<String>(
  'SignIn',
  debugLabel: 'sSelectedSignInOption',
);

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'todaily',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const <ButtonSegment<String>>[
                      ButtonSegment<String>(
                        value: 'SignIn',
                        label: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ButtonSegment<String>(
                        value: 'SignUp',
                        label: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ButtonSegment<String>(
                        value: 'TryOut',
                        label: Text(
                          'Try Out',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    selected: <String>{sSelectedSignInOption.value},
                    onSelectionChanged: (Set<String> newSelection) {
                      // Set the sSelectedSignInOption signal and watch
                      // it in the IndexedStack
                      sSelectedSignInOption.value = newSelection.first;
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: IndexedStack(
                index: sSelectedSignInOption.watch(context) == 'SignIn'
                    ? 0
                    : sSelectedSignInOption.watch(context) == 'SignUp'
                    ? 1
                    : 2,
                children: const <Widget>[
                  SignInContents(),
                  SignUpContents(),
                  TryOutContents(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
