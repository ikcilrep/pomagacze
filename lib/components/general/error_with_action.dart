import 'package:flutter/material.dart';
import 'package:pomagacze/utils/snackbar.dart';

class ErrorWithAction extends StatefulWidget {
  final VoidCallback action;
  final String actionText;
  final String errorText;
  final Object? error;

  const ErrorWithAction(
      {Key? key,
      required this.action,
      required this.actionText,
      this.error,
      this.errorText = 'Coś poszło nie tak...'})
      : super(key: key);

  @override
  State<ErrorWithAction> createState() => _ErrorWithActionState();
}

class _ErrorWithActionState extends State<ErrorWithAction> {
  @override
  void initState() {
    super.initState();
    if (widget.error != null) {
      context.showErrorSnackBar(message: widget.error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.errorText,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        OutlinedButton(onPressed: widget.action, child: Text(widget.actionText))
      ],
    );
  }
}
