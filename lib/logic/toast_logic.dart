import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  static void showSuccessToast({
    required String title,
    required String description,
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      showIcon: true,
      icon: const Icon(Icons.check_circle_outline),
      title: Text(title),
      description: Text(description),
      showProgressBar: true,
      pauseOnHover: true,
      dragToClose: true,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  static void showErrorToast({
    required String title,
    required String description,
  }) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      showIcon: true,
      icon: const Icon(Icons.error_outline_outlined),
      title: Text(title),
      description: Text(description),
      showProgressBar: true,
      pauseOnHover: true,
      dragToClose: true,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  static void showWarningToast({
    required String title,
    required String description,
  }) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      showIcon: true,
      icon: const Icon(Icons.warning_amber_outlined),
      title: Text(title),
      description: Text(description),
      showProgressBar: true,
      pauseOnHover: true,
      dragToClose: true,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}
