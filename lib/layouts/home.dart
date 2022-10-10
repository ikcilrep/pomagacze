import 'package:flutter/material.dart';
import 'package:pomagacze/components/auth_required_state.dart';
import 'package:pomagacze/components/indexed_transition_switcher.dart';
import 'package:pomagacze/pages/community.dart';
import 'package:pomagacze/pages/feed.dart';
import 'package:pomagacze/pages/profile.dart';
import 'package:animations/animations.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

const destinations = [
  NavigationDestination(icon: Icon(Icons.handshake), label: 'Pomagaj'),
  NavigationDestination(icon: Icon(Icons.people), label: 'Społeczność'),
  NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profil'),
];

class _HomeLayoutState extends AuthRequiredState<HomeLayout> {
  int _index = 0;
  bool _reversed = false;

  final List<Widget> _pages = [
    const FeedPage(key: PageStorageKey('feed')),
    const CommunityPage(key: PageStorageKey('community')),
    const ProfilePage(key: PageStorageKey('profile'))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(destinations[_index].label), scrolledUnderElevation: 0),
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
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
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
