import 'dart:ui';

import 'package:flutter/material.dart';

class CustomScrollConfiguration extends StatelessWidget {
  const CustomScrollConfiguration({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
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
      child: child,
    );
  }
}
