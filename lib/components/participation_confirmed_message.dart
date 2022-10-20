import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ParticipationConfirmedMessage extends StatelessWidget {
  const ParticipationConfirmedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Icon(Icons.done, size: 100, color: Colors.teal),
      Text("Twoje uczestnictwo zostało już potwierdzone.",
          textAlign: TextAlign.center)
    ]);
  }
}
