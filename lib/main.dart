import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:todaily/main_screen.dart';
import 'package:todaily/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the application documents directory
  final Directory dir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(dir.path); // Initialize Hive with the directory

  await Hive.openBox<String>('titles'); // Open the 'titles' box

  runApp(const MainEntry());
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.light, home: const MainScreen());
  }
}
