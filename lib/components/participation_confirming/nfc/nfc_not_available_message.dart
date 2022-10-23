import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NfcNotAvailableMessage extends StatelessWidget {
  const NfcNotAvailableMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Icon(Icons.error, size: 100),
      Text("NFC nie jest dostępne na twoim urządzeniu",
          textAlign: TextAlign.center)
    ]);
  }
}
