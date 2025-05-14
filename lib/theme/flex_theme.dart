import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/theme/themecolors_carousel.dart';
import 'package:todaily/theme/themefont_carousel.dart';
import 'package:todaily/theme/thememode_carousel.dart';

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
          // Using FlexColorScheme built-in FlexScheme enum based colors
          scheme: sFlexScheme.value,
          // Component theme configurations for light mode.
          subThemesData: const FlexSubThemesData(
            interactionEffects: true,
            tintedDisabledControls: true,
            blendOnColors: true,
            useMaterial3Typography: true,
            adaptiveSplash: FlexAdaptive.all(),
            splashType: FlexSplashType.defaultSplash,
            switchThumbFixedSize: true,
            unselectedToggleIsColored: true,
            sliderValueTinted: true,
            sliderTrackHeight: 24,
            inputDecoratorIsFilled: true,
            inputDecoratorBorderType: FlexInputBorderType.outline,
            inputDecoratorRadius: 12,
            listTileContentPadding: EdgeInsetsDirectional.fromSTEB(
              16,
              0,
              16,
              0,
            ),
            listTileMinVerticalPadding: 0,
            chipBlendColors: true,
            alignedDropdown: true,
            tooltipRadius: 4,
            tooltipSchemeColor: SchemeColor.inverseSurface,
            tooltipOpacity: 0.9,
            snackBarRadius: 12,
            snackBarElevation: 6,
            snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
            bottomAppBarHeight: 64,
            tabBarIndicatorWeight: 4,
            tabBarIndicatorTopRadius: 4,
            menuBarRadius: 12,
            menuBarShadowColor: Color(0x00000000),
            menuIndicatorRadius: 12,
            searchUseGlobalShape: true,
            navigationRailUseIndicator: true,
          ),
          // ColorScheme seed generation configuration for light mode.
          keyColors: const FlexKeyColors(useExpressiveOnContainerColors: true),
          // Direct ThemeData properties.
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          cupertinoOverrideTheme: const CupertinoThemeData(
            applyThemeToAll: true,
          ),

          fontFamily: sFont.value,
        )
      : FlexThemeData.dark(
          // Using FlexColorScheme built-in FlexScheme enum based colors.
          scheme: sFlexScheme.value,
          // Component theme configurations for dark mode.
          subThemesData: const FlexSubThemesData(
            interactionEffects: true,
            tintedDisabledControls: true,
            blendOnColors: true,
            useMaterial3Typography: true,
            adaptiveSplash: FlexAdaptive.all(),
            splashType: FlexSplashType.defaultSplash,
            switchThumbFixedSize: true,
            unselectedToggleIsColored: true,
            sliderValueTinted: true,
            sliderTrackHeight: 24,
            inputDecoratorIsFilled: true,
            inputDecoratorBorderType: FlexInputBorderType.outline,
            inputDecoratorRadius: 12,
            listTileContentPadding: EdgeInsetsDirectional.fromSTEB(
              16,
              0,
              16,
              0,
            ),
            listTileMinVerticalPadding: 0,
            chipBlendColors: true,
            alignedDropdown: true,
            tooltipRadius: 4,
            tooltipSchemeColor: SchemeColor.inverseSurface,
            tooltipOpacity: 0.9,
            snackBarRadius: 12,
            snackBarElevation: 6,
            snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
            bottomAppBarHeight: 64,
            tabBarIndicatorWeight: 4,
            tabBarIndicatorTopRadius: 4,
            menuBarRadius: 12,
            menuBarShadowColor: Color(0x00000000),
            menuIndicatorRadius: 12,
            searchUseGlobalShape: true,
            navigationRailUseIndicator: true,
          ),
          // ColorScheme seed configuration setup for dark mode.
          keyColors: const FlexKeyColors(),
          // Direct ThemeData properties.
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          cupertinoOverrideTheme: const CupertinoThemeData(
            applyThemeToAll: true,
          ),
          fontFamily: sFont.value,
        );
}, debugLabel: 'cThemeData');
