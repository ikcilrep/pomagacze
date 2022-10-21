import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';

final nfcAvailabilityProvider =
    FutureProvider((ref) => NfcManager.instance.isAvailable());
