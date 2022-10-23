import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomagacze/models/help_event.dart';

class CongratulationsDialog extends StatelessWidget {
  final HelpEvent event;
  final void Function() onDismiss;

  const CongratulationsDialog({super.key, required this.event, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Gratulacje!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Twój udział w wydarzeniu ${event.title} został potwierdzony!",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "+${event.points}",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(width: 3),
                      Icon(Icons.favorite,
                        color: Theme.of(context).colorScheme.error, size: 37,)
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(onPressed: onDismiss,child: const Text("Zamknij"),)
                ])));
  }


}