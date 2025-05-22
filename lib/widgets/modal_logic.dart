import 'package:flutter/material.dart';
import 'package:todaily/logic/scrollconfiguration_logic.dart';

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
      return CustomScrollConfiguration(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.64,
            ),
            child: child,
          ),
        ),
      );
    },
  );
}
