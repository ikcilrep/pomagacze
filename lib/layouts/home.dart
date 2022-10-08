import 'package:flutter/material.dart';
import 'package:pomagacze/pages/feed.dart';
import 'package:pomagacze/pages/profile.dart';
import 'package:pomagacze/pages/request_help.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

const destinations = [
  NavigationDestination(icon: Icon(Icons.handshake), label: 'Pomagaj'),
  NavigationDestination(icon: Icon(Icons.add), label: 'Zleć pomoc'),
  NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profil'),
];

class _HomeLayoutState extends State<HomeLayout> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(destinations[_index].label)),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() {
          _index = i;
        }),
      ),
    );
  }

  Widget _buildBody() {
    switch(_index) {
      case 0:
        return const FeedPage();
      case 1:
        return const RequestHelpPage();
      case 2:
        return const ProfilePage();
      default:
        return Container();
    }
  }
}
