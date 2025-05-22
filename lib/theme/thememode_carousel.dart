import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/logic/scrollconfiguration_logic.dart';

// Signal for the current ThemeMode. Defaults to system.
final Signal<ThemeMode> sThemeMode = Signal<ThemeMode>(
  ThemeMode.system,
  debugLabel: 'sThemeMode',
);

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
      child: CustomScrollConfiguration(
        child: CarouselView(
          itemExtent: 100,
          shrinkExtent: 60,
          itemSnapping: true,
          onTap: (int index) {
            sThemeMode.value = themeModes[index]['mode'] as ThemeMode;
          },
          children: themeModes.map((Map<String, dynamic> themeMode) {
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
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
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
