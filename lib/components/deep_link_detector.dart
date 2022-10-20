import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomagacze/db/events.dart';
import 'package:pomagacze/pages/event_details.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkDetector extends StatefulWidget {
  final Widget child;

  const DeepLinkDetector({Key? key, required this.child}) : super(key: key);

  @override
  State<DeepLinkDetector> createState() => _DeepLinkDetectorState();
}

class _DeepLinkDetectorState extends State<DeepLinkDetector> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initUniLinks();
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


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
