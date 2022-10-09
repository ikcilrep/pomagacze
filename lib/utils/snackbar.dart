import 'package:flutter/material.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color? backgroundColor,
    Color? color,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(color: Theme.of(this).colorScheme.onSurface)),
      backgroundColor: backgroundColor ?? Theme.of(this).colorScheme.surface,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}