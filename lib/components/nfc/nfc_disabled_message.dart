import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/error_with_action.dart';
import 'package:pomagacze/state/nfc.dart';

class NfcDisabledMessage extends ConsumerWidget {
  const NfcDisabledMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ErrorWithAction(
        actionText: "Odśwież",
        action: () {
          ref.refresh(nfcAvailabilityProvider);
        },
        errorText:
        "NFC na twoim urządzeniu jest wyłączone. Włącz je w ustawieniach telefonu.");
  }

}