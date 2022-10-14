import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchUsersPage extends ConsumerStatefulWidget {
  const SearchUsersPage({Key? key}) : super(key: key);

  @override
  SearchUsersState createState() => SearchUsersState();
}

class SearchUsersState extends ConsumerState<SearchUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Szukaj znajomych'),
        ),
        body: Container());
  }
}
