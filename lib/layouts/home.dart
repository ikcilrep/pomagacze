import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/components/indexed_transition_switcher.dart';
import 'package:pomagacze/pages/feed.dart';
import 'package:pomagacze/pages/friends.dart';
import 'package:pomagacze/pages/leaderboard.dart';
import 'package:pomagacze/pages/my_profile.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends AuthRequiredState<HomeLayout> {
  int _index = 0;
  bool _reversed = false;

  final List<Widget> _pages = [
    const FeedPage(key: PageStorageKey('feed')),
    const FriendsPage(key: PageStorageKey('friends')),
    const LeaderboardPage(key: PageStorageKey('leaderboard')),
    const MyProfilePage(key: PageStorageKey('profile'))
  ];

  List<NavigationDestination> get destinations => [
        NavigationDestination(
            icon:
                Icon(_index == 0 ? Icons.handshake : Icons.handshake_outlined),
            label: 'Pomagaj'),
        NavigationDestination(
            icon: Icon(_index == 1 ? Icons.people : Icons.people_outline),
            label: 'Znajomi'),
        NavigationDestination(
            icon: Icon(
                _index == 2 ? Icons.leaderboard : Icons.leaderboard_outlined),
            label: 'Rankingi'),
        NavigationDestination(
            icon: Icon(_index == 3
                ? Icons.account_circle
                : Icons.account_circle_outlined),
            label: 'Profil'),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(destinations[_index].label), scrolledUnderElevation: 0, actions: _index == 0 ? [
            IconButton(onPressed: () {
              Navigator.of(context).pushNamed('/learn');
            }, icon: const Icon(Icons.school, color: Colors.black87))
      ] : []),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() {
          _reversed = i < _index;
          _index = i;
        }),
      ),
    );
  }

  Widget _buildBody() {
    return IndexedTransitionSwitcher(
      reverse: _reversed,
      transitionBuilder: (Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      index: _index,
      children: _pages,
    );
  }
}
