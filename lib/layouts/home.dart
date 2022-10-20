import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/components/deep_link_detector.dart';
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

  List<NavigationDestination> destinations = const [
        NavigationDestination(
            selectedIcon: Icon(Icons.handshake),
            icon: Icon(Icons.handshake_outlined),
            label: 'Pomagaj'),
        NavigationDestination(
            selectedIcon: Icon(Icons.people),
            icon: Icon(Icons.people_outline),
            label: 'Znajomi'),
        NavigationDestination(
            selectedIcon: Icon(Icons.leaderboard),
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Rankingi'),
        NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profil'),
      ];

  @override
  Widget build(BuildContext context) {
    return DeepLinkDetector(
      child: Scaffold(
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
