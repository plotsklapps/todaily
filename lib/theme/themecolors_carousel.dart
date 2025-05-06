// Signal for the current FlexScheme. Defaults to outerSpace.
import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

final Signal<FlexScheme> sFlexScheme = Signal<FlexScheme>(
  FlexScheme.outerSpace,
  debugLabel: 'sFlexScheme',
);

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
