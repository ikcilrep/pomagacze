import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:pomagacze/components/congratulations_dialog.dart';
import 'package:pomagacze/components/nfc_not_available_message.dart';
import 'package:pomagacze/components/nfc_read_message.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/state/nfc.dart';
import 'package:pomagacze/utils/snackbar.dart';

class NfcReader extends ConsumerStatefulWidget {
  final HelpEvent event;

  const NfcReader({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NfcReaderState();
}

class NfcReaderState extends ConsumerState<NfcReader> {
  @override
  Widget build(BuildContext context) {
    final isNfcAvailableFuture = ref.watch(nfcAvailabilityProvider);
    return isNfcAvailableFuture.when(
        data: (isNfcAvailable) {
          scanNfcTag();
          return isNfcAvailable
              ? const NfcReadMessage()
              : const NfcNotAvailableMessage();
        },
        error: (err, stack) => Center(child: Text('Coś poszło nie tak: $err')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  void _showCongratulationsDialog() {
    if (mounted) {
      showDialog(
          context: context,
          builder: (_) => CongratulationsDialog(
              event: widget.event,
              onDismiss: () => Navigator.of(context).pop()));
    }
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  Future<void> scanNfcTag() async {
    await NfcManager.instance.stopSession();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      final ndef = Ndef.from(tag);
      try {
        final message = await ndef!.read();
        final record = message.records.last;
        final eventId = utf8.decode(record.payload.sublist(1));
        if (eventId == widget.event.id) {
          _showCongratulationsDialog();
        } else if (mounted) {
          context.showErrorSnackBar(message: 'Niepoprawne dane wydarzenia.');
        }
      } catch (e) {
        print(e);
        context.showErrorSnackBar(
            message: 'Nie udało się odczytać danych wydarzenia.');
      }
    });
  }
}
