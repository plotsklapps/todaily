import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todaily/screens/today_screen.dart';
import 'package:todaily/theme/themecolors_carousel.dart';
import 'package:todaily/theme/themefont_carousel.dart';
import 'package:todaily/theme/thememode_carousel.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('todaily'),
          centerTitle: true,
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const FaIcon(FontAwesomeIcons.bars),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'yesterday'),
              Tab(text: 'today'),
              Tab(text: 'tomorrow'),
            ],
          ),
        ),
        endDrawer: Drawer(
          child: Column(
            children: <Widget>[
              const DrawerHeader(child: Center(child: Text('todaily'))),
              Expanded(
                child: SingleChildScrollView(
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16,
                                        ),
                                        child: FilledButton(
                                          onPressed: () {
                                            // Save theme settings.
                                          },
                                          child: const FaIcon(
                                            FontAwesomeIcons.floppyDisk,
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
                      ListTile(
                        title: const Text('Version'),
                        onTap: () {
                          // Handle version update tap
                        },
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[TodayScreen(), TodayScreen(), TodayScreen()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const FaIcon(FontAwesomeIcons.floppyDisk),
        ),
      ),
    );
  }
}
