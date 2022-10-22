import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:pomagacze/components/nfc/nfc_disabled_message.dart';
import 'package:pomagacze/components/nfc/nfc_not_available_message.dart';
import 'package:pomagacze/components/nfc/nfc_write_message.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/state/nfc.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/snackbar.dart';

class NfcWriter extends ConsumerStatefulWidget {
  final HelpEvent event;

  const NfcWriter({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NfcWriterState();
}

class NfcWriterState extends ConsumerState<NfcWriter> {
  Widget _screenContent(NFCAvailability nfcAvailability) {
    switch (nfcAvailability) {
      case NFCAvailability.not_supported:
        return const NfcNotAvailableMessage();
      case NFCAvailability.disabled:
        return const NfcDisabledMessage();
      case NFCAvailability.available:
        return const NfcWriteMessage();
    }
  }
  @override
  Widget build(BuildContext context) {
    final nfcAvailabilityAsyncValue = ref.watch(nfcAvailabilityProvider);
    return nfcAvailabilityAsyncValue.when(
        data: (nfcAvailability) {
          if (nfcAvailability == NFCAvailability.available) _scanNfcTag();
          return _screenContent(nfcAvailability);
        },
        error: (err, stack) => Center(child: Text('Coś poszło nie tak: $err')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  Future<void> _scanNfcTag() async {
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
        NdefRecord.createUri(
            Uri.parse('$websiteUrl/confirm-event/${widget.event.id}')),
        NdefRecord(
            typeNameFormat: NdefTypeNameFormat.nfcExternal,
            type: Uint8List.fromList('android.com:pkg'.codeUnits),
            identifier: Uint8List.fromList([]),
            payload: Uint8List.fromList('com.pomagacze.pomagacze'.codeUnits))
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
