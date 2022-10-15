import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/fab_extended_animated.dart';
import 'package:pomagacze/components/user_list_tile.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/state/friendships.dart';

class ManageFriendsPage extends ConsumerStatefulWidget {
  const ManageFriendsPage({Key? key}) : super(key: key);

  @override
  ManageFriendsPageState createState() => ManageFriendsPageState();
}

class ManageFriendsPageState extends ConsumerState<ManageFriendsPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final friends = ref.watch(friendsProvider);
    final outgoingRequests = ref.watch(outgoingFriendRequestsProvider);
    final incomingRequests = ref.watch(incomingFriendRequestsProvider);

    return Scaffold(
      floatingActionButton: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ScrollingFabAnimated(
          scrollController: _scrollController,
          text: Text('Szukaj znajomych',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
          icon:
              Icon(Icons.search, color: Theme.of(context).colorScheme.onPrimary),
          onPress: () {
            Navigator.of(context).pushNamed('/search-users');
          },
          radius: 18,
          width: 185,
          elevation: 10,
          animateIcon: false,
          color: Theme.of(context).colorScheme.primary,
          duration: const Duration(milliseconds: 150),
        ),
      ),
      body: friends.isLoading ||
              outgoingRequests.isLoading ||
              incomingRequests.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.refresh(friendsIdsProvider.future),
              child: ListView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildList('Przychodzące zaproszenia do znajomych',
                      incomingRequests.valueOrNull ?? [], (r) => r.sender),
                  _buildList('Wychodzące zaproszenia do znajomych',
                      outgoingRequests.valueOrNull ?? [], (r) => r.target),
                  _buildList('Znajomi', friends.valueOrNull ?? [], (u) => u),
                ],
              ),
            ),
    );
  }

  Widget _buildList<T>(String title, List<T> list,
      UserProfile? Function(T element) userGetter) {
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
          child: Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return UserListTile(
                  userProfile: userGetter(list[i]) ?? UserProfile.empty());
            },
            itemCount: list.length)
      ],
    );
  }
}
