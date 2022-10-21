import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/nfc_not_available_message.dart';
import 'package:pomagacze/components/nfc_write_message.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/state/nfc.dart';
import 'package:ndef/ndef.dart' as ndef;
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
    final nfcAvailability = ref.read(nfcAvailabilityProvider);
    return nfcAvailability.when(
        data: (nfcAvailability) {
          scanNfcTag(nfcAvailability);
          return nfcAvailability == NFCAvailability.available
              ? const NfcWriteMessage()
              : const NfcNotAvailableMessage();
        },
        error: (err, stack) => Center(child: Text('Coś poszło nie tak: $err')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  Future<void> scanNfcTag(NFCAvailability nfcAvailability) async {
    while (mounted) {
      try {
        final tag = await FlutterNfcKit.poll();
        if (tag.ndefWritable == true) {
          // decoded NDEF records
          await FlutterNfcKit.writeNDEFRecords(
              [ndef.UriRecord.fromString(widget.event.id)]);
          await FlutterNfcKit.finish();
          if (mounted) {
            context.showSnackBar(
                message: "Zapisano dane wydarzenia na tagu NFC");
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
