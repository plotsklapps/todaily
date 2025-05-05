import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';

// Signal for the current ThemeMode. Defaults to system.
final Signal<ThemeMode> sThemeMode = Signal<ThemeMode>(
  ThemeMode.system,
  debugLabel: 'sThemeMode',
);

// Signal for the current FlexScheme. Defaults to outerSpace.
final Signal<FlexScheme> sFlexScheme = Signal<FlexScheme>(
  FlexScheme.outerSpace,
  debugLabel: 'sFlexScheme',
);

// Signal for the current font family. Defaults to Questrial.
final Signal<String> sFont = Signal<String>(
  GoogleFonts.questrial().fontFamily!,
  debugLabel: 'sFont',
);

// Computed for the ThemeData. Responds to changes in sThemeMode, sFlexScheme,
// and sFont Signals.
final Computed<ThemeData> cThemeData = Computed<ThemeData>(() {
  // Get the current ThemeMode from platformBrightness. Works on ALL platforms.
  final Brightness platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  final bool isSystemLight = platformBrightness == Brightness.light;

  final bool isLightTheme =
      sThemeMode.value == ThemeMode.light ||
      (sThemeMode.value == ThemeMode.system && isSystemLight);

  return isLightTheme
      ? FlexThemeData.light(
        scheme: sFlexScheme.value,
        subThemesData: const FlexSubThemesData(
          inputDecoratorIsDense: true,
          alignedDropdown: true,
          tooltipRadius: 4,
          tooltipSchemeColor: SchemeColor.inverseSurface,
          tooltipOpacity: 0.9,
          snackBarElevation: 6,
          snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
          navigationRailUseIndicator: true,
        ),
        keyColors: const FlexKeyColors(),
        visualDensity: VisualDensity.compact,
        cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
        fontFamily: sFont.value,
      )
      : FlexThemeData.dark(
        scheme: sFlexScheme.value,
        subThemesData: const FlexSubThemesData(
          blendOnColors: true,
          inputDecoratorIsDense: true,
          alignedDropdown: true,
          tooltipRadius: 4,
          tooltipSchemeColor: SchemeColor.inverseSurface,
          tooltipOpacity: 0.9,
          snackBarElevation: 6,
          snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
          navigationRailUseIndicator: true,
        ),
        keyColors: const FlexKeyColors(),
        visualDensity: VisualDensity.compact,
        cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
        fontFamily: sFont.value,
      );
}, debugLabel: 'cThemeData');

class ThemeModeCarousel extends StatelessWidget {
  const ThemeModeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> themeModes = <Map<String, dynamic>>[
      <String, dynamic>{
        'mode': ThemeMode.light,
        'name': 'Light',
        'icon': const FaIcon(FontAwesomeIcons.sun),
      },
      <String, dynamic>{
        'mode': ThemeMode.dark,
        'name': 'Dark',
        'icon': const FaIcon(FontAwesomeIcons.moon),
      },
      <String, dynamic>{
        'mode': ThemeMode.system,
        'name': 'System',
        'icon': const FaIcon(FontAwesomeIcons.android),
      },
    ];
    return SizedBox(
      height: 110,
      child: ScrollConfiguration(
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
        child: CarouselView(
          itemExtent: 100,
          shrinkExtent: 60,
          itemSnapping: true,
          onTap: (int index) {
            sThemeMode.value = themeModes[index]['mode'] as ThemeMode;
          },
          children:
              themeModes.map((Map<String, dynamic> themeMode) {
                final bool isSelected =
                    sThemeMode.watch(context) == themeMode['mode'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    themeMode['icon'] as Widget,
                    const SizedBox(height: 8),
                    Text(
                      themeMode['name'] as String,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}

class ThemeColorsCarousel extends StatelessWidget {
  const ThemeColorsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ScrollConfiguration(
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
        child: CarouselView(
          itemExtent: 100,
          shrinkExtent: 60,
          itemSnapping: true,
          onTap: (int index) {
            sFlexScheme.value = FlexScheme.values[index];
          },
          children:
              FlexScheme.values.map((FlexScheme scheme) {
                final bool isSelected = sFlexScheme.watch(context) == scheme;
                final ThemeData theme = FlexThemeData.light(scheme: scheme);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.zero,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: <Widget>[
                          _colorBox(theme.colorScheme.primary),
                          _colorBox(theme.colorScheme.secondary),
                          _colorBox(theme.colorScheme.tertiary),
                          _colorBox(theme.colorScheme.primaryFixed),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scheme.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _colorBox(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class ThemeFontCarousel extends StatelessWidget {
  const ThemeFontCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> fontNames = <String>[
      GoogleFonts.roboto().fontFamily!,
      GoogleFonts.openSans().fontFamily!,
      GoogleFonts.lato().fontFamily!,
      GoogleFonts.montserrat().fontFamily!,
      GoogleFonts.poppins().fontFamily!,
      GoogleFonts.raleway().fontFamily!,
      GoogleFonts.notoSans().fontFamily!,
      GoogleFonts.oswald().fontFamily!,
      GoogleFonts.merriweather().fontFamily!,
      GoogleFonts.inter().fontFamily!,
      GoogleFonts.ptSans().fontFamily!,
      GoogleFonts.sourceSans3().fontFamily!,
      GoogleFonts.nunito().fontFamily!,
      GoogleFonts.playfairDisplay().fontFamily!,
      GoogleFonts.quicksand().fontFamily!,
      GoogleFonts.workSans().fontFamily!,
      GoogleFonts.cabin().fontFamily!,
      GoogleFonts.ubuntu().fontFamily!,
      GoogleFonts.dancingScript().fontFamily!,
      GoogleFonts.firaSans().fontFamily!,
      GoogleFonts.josefinSans().fontFamily!,
      GoogleFonts.mulish().fontFamily!,
      GoogleFonts.barlow().fontFamily!,
      GoogleFonts.inconsolata().fontFamily!,
      GoogleFonts.lora().fontFamily!,
      GoogleFonts.titilliumWeb().fontFamily!,
      GoogleFonts.varelaRound().fontFamily!,
      GoogleFonts.zillaSlab().fontFamily!,
      GoogleFonts.questrial().fontFamily!,
      GoogleFonts.manrope().fontFamily!,
    ];

    return SizedBox(
      height: 110,
      child: ScrollConfiguration(
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
        child: CarouselView(
          itemExtent: 100,
          shrinkExtent: 60,
          itemSnapping: true,
          onTap: (int index) {
            sFont.value = fontNames[index];
          },
          children:
              fontNames.map((String fontName) {
                final bool isSelected = sFont.watch(context) == fontName;
                final String baseFontName = fontName.split('_')[0];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Lorem ipsum dolor sit amet...',
                      style: TextStyle(
                        fontFamily: fontName,
                        fontSize: 16,
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      baseFontName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
