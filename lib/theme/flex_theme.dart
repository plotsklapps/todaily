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
        scheme: sFlexScheme.value,
        subThemesData: const FlexSubThemesData(
          interactionEffects: true,
          tintedDisabledControls: true,
          useMaterial3Typography: true,
          unselectedToggleIsColored: true,
          sliderValueTinted: true,
          inputDecoratorContentPadding: EdgeInsetsDirectional.fromSTEB(
            12,
            12,
            12,
            12,
          ),
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorRadius: 12,
          listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          listTileMinVerticalPadding: 0,
          chipPadding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
          alignedDropdown: true,
          tooltipRadius: 4,
          tooltipSchemeColor: SchemeColor.inverseSurface,
          tooltipOpacity: 0.9,
          useInputDecoratorThemeInDialogs: true,
          snackBarElevation: 6,
          snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
          appBarCenterTitle: true,
          drawerWidth: 300,
          drawerIndicatorWidth: 300,
          navigationRailUseIndicator: true,
        ),
        keyColors: const FlexKeyColors(),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
        fontFamily: sFont.value,
      )
      : FlexThemeData.dark(
        scheme: sFlexScheme.value,
        subThemesData: const FlexSubThemesData(
          interactionEffects: true,
          tintedDisabledControls: true,
          blendOnColors: true,
          useMaterial3Typography: true,
          unselectedToggleIsColored: true,
          sliderValueTinted: true,
          inputDecoratorContentPadding: EdgeInsetsDirectional.fromSTEB(
            12,
            12,
            12,
            12,
          ),
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorRadius: 12,
          listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          listTileMinVerticalPadding: 0,
          chipPadding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
          alignedDropdown: true,
          tooltipRadius: 4,
          tooltipSchemeColor: SchemeColor.inverseSurface,
          tooltipOpacity: 0.9,
          useInputDecoratorThemeInDialogs: true,
          snackBarElevation: 6,
          snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
          appBarCenterTitle: true,
          drawerWidth: 300,
          drawerIndicatorWidth: 300,
          navigationRailUseIndicator: true,
        ),
        keyColors: const FlexKeyColors(),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
        fontFamily: sFont.value,
      );
}, debugLabel: 'cThemeData');
