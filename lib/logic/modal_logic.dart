import 'package:flutter/material.dart';

Future<void> showModalSheet({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<void>(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return child;
    },
  );
}
