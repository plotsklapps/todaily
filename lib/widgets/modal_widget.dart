import 'dart:ui';

import 'package:flutter/material.dart';

// Custom way to show a modal bottom sheet with a drag handle and
// scrollable content for all devices.
Future<void> showModal({
  required BuildContext context,
  required Widget child,
}) async {
  return showModalBottomSheet<void>(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
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
        child: SingleChildScrollView(child: child),
      );
    },
  );
}
