import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showSuccessToast({required String message}) {
  toastification.show(
    title: Text(message),
    alignment: Alignment.bottomCenter,
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    showIcon: true,
    autoCloseDuration: const Duration(seconds: 5),
  );
}

void showWarningToast({required String message}) {
  toastification.show(
    title: Text(message),
    alignment: Alignment.bottomCenter,
    type: ToastificationType.warning,
    style: ToastificationStyle.flatColored,
    showIcon: true,
    autoCloseDuration: const Duration(seconds: 5),
  );
}

void showErrorToast({required String message}) {
  toastification.show(
    title: Text(message),
    alignment: Alignment.bottomCenter,
    type: ToastificationType.error,
    style: ToastificationStyle.flatColored,
    showIcon: true,
    autoCloseDuration: const Duration(seconds: 5),
  );
}
