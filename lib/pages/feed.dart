import 'package:flutter/material.dart';
import 'package:pomagacze/components/fab_extended_animated.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/components/request_card.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/help_request.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends AuthRequiredState<FeedPage> {
  late Future<List<HelpRequest>> _feedFuture;
  bool _fabExtended = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _feedFuture = RequestsDB.getAll();
    _scrollController.addListener(() {
      setState(() {
        _fabExtended = !_scrollController.hasClients ||
            _scrollController.position.pixels == 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(),
        ),
        _buildList(),
        _buildFAB(),
      ],
    );
  }

  Widget _buildFAB() {
    return Positioned(
        bottom: 15,
        right: 10,
        child: ScrollingFabAnimated(
          scrollController: _scrollController,
          text: Text('Dodaj zgłoszenie', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
          onPress: () {},
          radius: 18,
          width: 180,
          animateIcon: false,
          color: Theme.of(context).colorScheme.primary,
        ));
  }

  Widget _buildList() {
    return FutureBuilder(
        future: _feedFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('Coś poszło nie tak'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data as List<HelpRequest>;
          return ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) => RequestCard(data[index]),
              itemCount: data.length);
        });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
