import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/error_with_action.dart';
import 'package:pomagacze/components/user_list_tile.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/state/user.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:share_plus/share_plus.dart';

class SearchUsersPage extends ConsumerStatefulWidget {
  const SearchUsersPage({Key? key}) : super(key: key);

  @override
  SearchUsersState createState() => SearchUsersState();
}

class SearchUsersState extends ConsumerState<SearchUsersPage> {
  final _searchFieldController = TextEditingController();
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _searchFieldController.addListener(() {
      if (_previousText != _searchFieldController.text) {
        ref.invalidate(searchUsersProvider);
        _previousText = _searchFieldController.text;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var users = ref.watch(searchUsersProvider(_searchFieldController.text));

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchFieldController,
            decoration: const InputDecoration(hintText: 'Szukaj znajomych...'),
            autofocus: true,
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: users.when(
            data: (data) => _buildList(data),
            error: (err, stack) {
              print(err);
              return ErrorWithAction(
                  action: () => ref.invalidate(searchUsersProvider),
                  actionText: 'Odśwież');
            },
            loading: () => const Center(child: CircularProgressIndicator())));
  }

  Widget _buildList(List<UserProfile> users) {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 5),
        itemBuilder: (context, i) {
          if (i == 0) {
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 21, vertical: 5),
              title: const Text('Zaproś znajomych do aplikacji'),
              leading: const Icon(Icons.person_add),
              onTap: () {
                Share.share('Pomagajmy wspólnie! Zainstaluj aplikację Pomagacze i dodaj mnie do znajomych - $websiteUrl/install');
              },
            );
          }
          return UserListTile(userProfile: users[i - 1]);
        },
        itemCount: users.length + 1);
  }
}
