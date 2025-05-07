import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce/hive.dart';
import 'package:todaily/theme/themecolors_carousel.dart';
import 'package:todaily/theme/themefont_carousel.dart';
import 'package:todaily/theme/thememode_carousel.dart';
import 'package:todaily/widgets/toast_widget.dart';

Future<void> saveThemeSettings({required BuildContext context}) async {
  // Get the current values from the Signals and convert them to String.
  final String themeMode = sThemeMode.value.toString();
  final String flexScheme = sFlexScheme.value.name;
  final String font = sFont.value;

  // Store the values in the Hive settings box.
  await Hive.box<dynamic>('settings').put('themeMode', themeMode);
  await Hive.box<dynamic>('settings').put('flexScheme', flexScheme);
  await Hive.box<dynamic>('settings').put('font', font);

  // Show a success message.
  showSuccesToast(title: 'Successfully stored theme settings!');
}

Future<void> loadThemeSettings() async {
  final Box<dynamic> settingsBox = Hive.box('settings');

  final String? themeMode = settingsBox.get('themeMode') as String?;
  final String? flexScheme = settingsBox.get('flexScheme') as String?;
  final String? font = settingsBox.get('font') as String?;

  // Update the Signals with the loaded values.
  sThemeMode.value =
      themeMode != null
          ? ThemeMode.values.firstWhere(
            (ThemeMode e) => e.toString() == themeMode,
          )
          : ThemeMode.system;

  sFlexScheme.value =
      flexScheme != null
          ? FlexScheme.values.firstWhere((FlexScheme e) => e.name == flexScheme)
          : FlexScheme.outerSpace;

  sFont.value = font ?? GoogleFonts.questrial().fontFamily!;
}
