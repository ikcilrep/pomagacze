import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/events.dart';
import 'package:pomagacze/db/volunteers.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/pages/event_details.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/state/leaderboard.dart';
import 'package:pomagacze/state/users.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:uni_links/uni_links.dart';

import 'congratulations_dialog.dart';

class DeepLinkDetector extends ConsumerStatefulWidget {
  final Widget child;

  const DeepLinkDetector({Key? key, required this.child}) : super(key: key);

  @override
  ConsumerState<DeepLinkDetector> createState() => _DeepLinkDetectorState();
}

class _DeepLinkDetectorState extends ConsumerState<DeepLinkDetector> {
  StreamSubscription? _sub;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initUniLinks();
    _checkNdefIntent();
  }

  @override
  void dispose() {
    super.dispose();
    _sub?.cancel();
  }

  Future<void> _initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) async {
      if(uri == null) return;

      try {
        if (uri.scheme == 'com.pomagacze.pomagacze' && uri.host == 'event' && uri.pathSegments.length == 1) {
          var event = await EventsDB.getById(uri.pathSegments[0]);
          if (mounted) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EventDetails(event)));
          }
        }
      } catch (err) {
        print(err);
      }
    }, onError: (err) {
      print(err);
    });
  }

  Future<void> _checkNdefIntent() async {
    try {
      final receivedIntent = await ReceiveIntent.getInitialIntent();
      if (receivedIntent?.action == 'android.nfc.action.NDEF_DISCOVERED') {
        var uri = Uri.tryParse(receivedIntent?.data ?? '');
        if (uri != null && uri.pathSegments.length == 2) {
          var id = uri.pathSegments[1];

          setState(() {
            _isLoading = true;
          });

          var volunteer = await VolunteersDB.get(id, supabase.auth.user()!.id)
              .catchError((err, stack) => null);
          if (volunteer?.isParticipationConfirmed == true && mounted) {
            context.showErrorSnackBar(
                message:
                    'Twoje uczestnictwo w tym wydarzeniu już zostało potwierdzone!');
            setState(() {
              _isLoading = false;
            });
            return;
          }

          var event = await EventsDB.getById(id);

          volunteer =
              Volunteer(userId: supabase.auth.user()!.id, eventId: event.id!, isParticipationConfirmed: true);
          await VolunteersDB.upsert(volunteer);

          ref.invalidate(feedFutureProvider);
          ref.invalidate(currentUserProvider);
          ref.invalidate(leaderboardProvider);

          setState(() {
            _isLoading = false;
          });

          if (mounted) {
            showDialog(
                context: context,
                builder: (_) => CongratulationsDialog(
                    event: event,
                    onDismiss: () {
                      Navigator.of(context).pop();
                    }));
          }
        }
      }
    } catch (err) {
      context.showErrorSnackBar(message: 'Coś poszło nie tak!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : widget.child;
  }
}
