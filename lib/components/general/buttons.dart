import 'package:flutter/material.dart';

ButtonStyle primaryButtonStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary);
}
