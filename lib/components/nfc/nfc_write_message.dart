import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NfcWriteMessage  extends StatelessWidget {
  const NfcWriteMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.nfc, size: 100),
          Text("Przyłóż tag NFC, aby zapisać dane wydarzenia.",
              textAlign: TextAlign.center)
        ]);
  }

}