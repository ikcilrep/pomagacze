import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/models/help_event.dart';

class ConfirmParticipationPage extends ConsumerStatefulWidget {
  final HelpEvent event;

  const ConfirmParticipationPage({Key? key, required this.event})
      : super(key: key);

  @override
  ConsumerState<ConfirmParticipationPage> createState() =>
      _ConfirmParticipationPageState();
}

class _ConfirmParticipationPageState
    extends ConsumerState<ConfirmParticipationPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Potwierdź uczestnictwo'),
          bottom: TabBar(
            tabs: const [Tab(text: 'NFC', icon: Icon(Icons.nfc)), Tab(text: 'W pobliżu', icon: Icon(Icons.wifi))],
            labelColor: Theme.of(context).colorScheme.onSurface,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: TabBarView(
          children: [Container(), Container()],
        ),
      ),
    );
  }
}
