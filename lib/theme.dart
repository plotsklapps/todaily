import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';

// Signal for the current theme mode. Defaults to light.
final Signal<bool> sThemeLight = Signal<bool>(true, debugLabel: 'sThemeLight');

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

// Computed for the ThemeData. Responds to changes in sThemeLight,
// sFlexScheme, and sFont Signals.
final Computed<ThemeData> cThemeData = Computed<ThemeData>(() {
  return sThemeLight.value
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

class ThemeCarousel extends StatelessWidget {
  const ThemeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
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
          itemExtent: 120,
          shrinkExtent: 100,
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
                    Container(
                      color: theme.colorScheme.surface,
                      height: 80,
                      width: 80,
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
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class FontCarousel extends StatelessWidget {
  const FontCarousel({super.key});

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
      height: 132,
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
          itemExtent: 120,
          shrinkExtent: 100,
          itemSnapping: true,
          onTap: (int index) {
            sFont.value = fontNames[index];
          },
          children:
              fontNames.map((String fontName) {
                // Only watch sFont when it's needed for highlighting.
                final bool isSelected = sFont.watch(context) == fontName;

                final String baseFontName = fontName.split('_')[0];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Use the current fontName for the "lorem ipsum" text
                    Text(
                      'Lorem ipsum dolor sit amet...',
                      style: TextStyle(
                        fontFamily: fontName, // Use the current fontName
                        fontSize: 18,
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
