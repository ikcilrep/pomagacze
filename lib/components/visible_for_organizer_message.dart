import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VisibleForOrganizerMessage extends StatelessWidget {
  const VisibleForOrganizerMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Icon(Icons.visibility_outlined, size: 100),
      Text("Jesteś widoczny dla organizatora w pobliżu.",
          textAlign: TextAlign.center)
    ]);
  }
}
