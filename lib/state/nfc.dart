import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nfcAvailabilityProvider =
    FutureProvider((ref) => FlutterNfcKit.nfcAvailability);
