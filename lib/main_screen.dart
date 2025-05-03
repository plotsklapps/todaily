import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todaily/today_screen.dart';

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
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  // Handle settings tap
                },
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
              const Divider(),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('Version 1.0.0')),
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
