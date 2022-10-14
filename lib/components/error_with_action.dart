import 'package:flutter/material.dart';

class ErrorWithAction extends StatelessWidget {
  final VoidCallback action;
  final String actionText;
  final String errorText;

  const ErrorWithAction(
      {Key? key,
      required this.action,
      required this.actionText,
      this.errorText = 'Coś poszło nie tak...'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorText),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: action, child: const Text('Wyloguj się'))
      ],
    );
  }
}
