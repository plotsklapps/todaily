import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/screens/main_screen.dart';
import 'package:todaily/theme/flex_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainEntry());
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: cThemeData.watch(context),
      home: const MainScreen(),
    );
  }
}
