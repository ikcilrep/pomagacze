import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NfcReadMessage  extends StatelessWidget {
  const NfcReadMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.nfc, size: 100),
          Text("Przyłóż tag NFC, aby odczytać dane wydarzenia.",
              textAlign: TextAlign.center)
        ]);
  }

}