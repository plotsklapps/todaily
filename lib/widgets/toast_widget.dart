import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showSuccesToast({required String title}) {
  toastification.show(
    title: Text(title),
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 5),
    showProgressBar: true,
    dragToClose: true,
  );
}
