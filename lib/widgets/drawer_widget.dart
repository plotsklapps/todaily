import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todaily/database/hive_settings.dart';
import 'package:todaily/scrollconfiguration_logic.dart';
import 'package:todaily/theme/themecolors_carousel.dart';
import 'package:todaily/theme/themefont_carousel.dart';
import 'package:todaily/theme/thememode_carousel.dart';
import 'package:web/web.dart' as web;

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(child: Center(child: Text('todaily'))),
          Expanded(
            child: CustomScrollConfiguration(
              child: Column(
                children: <Widget>[
                  // Remove the Divider from the ExpansionTile.
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const FaIcon(FontAwesomeIcons.gear),
                      title: const Text('Settings'),
                      subtitle: const Text('Customize your experience'),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: ExpansionTile(
                            leading: const FaIcon(FontAwesomeIcons.palette),
                            title: const Text(
                              'Theme',
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: const Text(
                              'Change your theme',
                              style: TextStyle(fontSize: 10),
                            ),
                            children: <Widget>[
                              const ThemeModeCarousel(),
                              const ThemeColorsCarousel(),
                              const ThemeFontCarousel(),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Expanded(
                                      child: FilledButton(
                                        onPressed: () {
                                          saveThemeSettings(context: context);
                                        },
                                        child: const FaIcon(
                                          FontAwesomeIcons.floppyDisk,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('About'),
                    onTap: () {
                      // Handle about tap
                    },
                  ),
                  ListTile(
                    title: const Text('Help'),
                    onTap: () {
                      // Handle help tap
                    },
                  ),
                  ListTile(
                    title: const Text('Feedback'),
                    onTap: () {
                      // Handle feedback tap
                    },
                  ),
                  // Remove the Divider from the ExpansionTile.
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const FaIcon(FontAwesomeIcons.arrowsRotate),
                      title: const Text('Version'),
                      subtitle: const Text('Check for updates'),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowUpFromBracket,
                            ),
                            title: const Text(
                              'Current Version',
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: const Text(
                              '0.0.1-alpha',
                              style: TextStyle(fontSize: 10),
                            ),
                            onTap: () {
                              web.window.location.reload();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
