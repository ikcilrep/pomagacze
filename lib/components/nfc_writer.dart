import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:pomagacze/components/nfc_not_available_message.dart';
import 'package:pomagacze/components/nfc_write_message.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/state/nfc.dart';
import 'package:pomagacze/utils/snackbar.dart';

class NfcWriter extends ConsumerStatefulWidget {
  final HelpEvent event;

  const NfcWriter({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NfcWriterState();
}

class NfcWriterState extends ConsumerState<NfcWriter> {
  @override
  Widget build(BuildContext context) {
    final isNfcAvailableFuture = ref.watch(nfcAvailabilityProvider);
    return isNfcAvailableFuture.when(
        data: (isNfcAvailable) {
          scanNfcTag();
          return isNfcAvailable
              ? const NfcWriteMessage()
              : const NfcNotAvailableMessage();
        },
        error: (err, stack) => Center(child: Text('Coś poszło nie tak: $err')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  Future<void> scanNfcTag() async {
    await NfcManager.instance.stopSession();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        const errorMessage = 'Na ten tag NFC nie da się zapisywać danych';
        context.showErrorSnackBar(message: errorMessage);
        NfcManager.instance.stopSession(errorMessage: errorMessage);
        return;
      }
      NdefMessage message = NdefMessage([
        NdefRecord.createText(widget.event.id!, languageCode: ''),
      ]);

      try {
        await ndef.write(message);
        if (mounted) {
          context.showSnackBar(
              message: 'Udało się pomyślnie zapisać dane na tagu NFC!');
        }
      } catch (e) {
        NfcManager.instance.stopSession(errorMessage: e.toString());
        return;
      }
    });
  }
}
