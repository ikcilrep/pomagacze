import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/components/fab_extended_animated.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/components/request_card.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/help_request.dart';
import 'package:pomagacze/pages/request_form.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends AuthRequiredState<FeedPage> {
  late Future<List<HelpRequest>> _feedFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _feedFuture = RequestsDB.getAll();
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
        child: OpenContainer<bool>(
            transitionType: ContainerTransitionType.fadeThrough,
            openBuilder: (BuildContext context, VoidCallback _) {
              return RequestForm();
            },
            tappable: false,
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            closedElevation: 1.5,
            // transitionDuration: const Duration(seconds: 2),
            closedBuilder: (_, openContainer) {
              return ScrollingFabAnimated(
                scrollController: _scrollController,
                text: Text('Poproś o pomoc',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
                icon: Icon(Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPress: openContainer,
                radius: 18,
                width: 180,
                elevation: 1.5,
                animateIcon: false,
                color: Theme.of(context).colorScheme.primary,
                duration: Duration(milliseconds: 150),
              );
            }));

    // return Positioned(
    // bottom: 15,
    // right: 10,
    // child: ScrollingFabAnimated(
    //   scrollController: _scrollController,
    //   text: Text('Poproś o pomoc',
    //       style: Theme.of(context)
    //           .textTheme
    //           .subtitle2
    //           ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
    //   icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
    //   onPress: () {
    //     Navigator.of(context).pushNamed('/new');
    //   },
    //   radius: 18,
    //   width: 180,
    //   animateIcon: false,
    //   color: Theme.of(context).colorScheme.primary,
    // ));
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: () async {
        var result = await RequestsDB.getAll();
        setState(() {
          _feedFuture = Future.value(result);
        });
      },
      child: FutureBuilder(
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
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
