import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:todaily/firebase_options.dart';
import 'package:todaily/screens/loading_screen.dart';
import 'package:todaily/state/gemini_signal.dart';
import 'package:todaily/theme/flex_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize the Gemini Developer API backend service.
  final GenerativeModel model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.0-flash',
  );

  // Assign the initialized model to the Signal.
  sGenerativeModel.value = model;

  runApp(const MainEntry());
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: cThemeData.watch(context),
        home: const LoadingScreen(),
      ),
    );
  }
}
