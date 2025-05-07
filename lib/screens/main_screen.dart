import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todaily/screens/today_screen.dart';
import 'package:todaily/widgets/drawer_widget.dart';

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
        endDrawer: const DrawerWidget(),
        body: const TabBarView(
          children: <Widget>[TodayScreen(), TodayScreen(), TodayScreen()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          child: const FaIcon(FontAwesomeIcons.floppyDisk),
        ),
      ),
    );
  }
}
