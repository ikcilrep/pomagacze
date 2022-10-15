import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/profile_action.dart';
import 'package:pomagacze/components/user_profile_details.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/state/friendships.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/snackbar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final UserProfile userProfile;

  const ProfilePage({Key? key, required this.userProfile}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil użytkownika')),
      body: UserProfileDetails(
        userProfile: widget.userProfile,
        children: [..._buildFriendRelatedItems()],
      ),
    );
  }

  List<Widget> _buildFriendRelatedItems() {
    if (widget.userProfile.id == supabase.auth.user()?.id) {
      return [];
    }

    var friendIds = ref.watch(friendsIdsProvider);
    var outgoingFriendRequests = ref.watch(outgoingFriendRequestsProvider);
    var incomingFriendRequests = ref.watch(incomingFriendRequestsProvider);

    if (friendIds.valueOrNull?.contains(widget.userProfile.id) == true) {
      return [
        ProfileAction(
            title: const Text('Usuń znajomego'),
            icon: const Icon(Icons.person_remove),
            onTap: () async {
              await FriendshipsDB.removeFriendship(
                      supabase.auth.currentUser!.id, widget.userProfile.id)
                  .catchError((err, stack) {
                if (mounted) {
                  context.showErrorSnackBar(message: err.toString());
                }
              });
              ref.invalidate(friendsIdsProvider);
            })
      ];
    }

    if (incomingFriendRequests.valueOrNull
            ?.any((x) => x.senderId == widget.userProfile.id) ==
        true) {
      return [
        ProfileAction(
          title: const Text('Akceptuj zaproszenie'),
          icon: const Icon(Icons.check),
          onTap: () async {
            await FriendshipsDB.acceptFriendRequest(
                    widget.userProfile.id, supabase.auth.currentUser!.id)
                .catchError((err, stack) {
              if (mounted) {
                context.showErrorSnackBar(message: err.toString());
              }
            });
            ref.invalidate(friendsIdsProvider);
          },
        ),
        ProfileAction(
          title: const Text('Odrzuć zaproszenie'),
          icon: const Icon(Icons.close),
          onTap: () async {
            await FriendshipsDB.cancelFriendRequest(
                    widget.userProfile.id, supabase.auth.currentUser!.id)
                .catchError((err, stack) {
              if (mounted) {
                context.showErrorSnackBar(message: err.toString());
              }
            });
            ref.invalidate(friendsIdsProvider);
          },
        )
      ];
    }

    if (outgoingFriendRequests.valueOrNull
            ?.any((x) => x.targetId == widget.userProfile.id) ==
        true) {
      return [
        ProfileAction(
          title: const Text('Anuluj wysłane zaproszenie'),
          icon: const Icon(Icons.person_add_disabled),
          onTap: () async {
            await FriendshipsDB.cancelFriendRequest(
                    supabase.auth.currentUser!.id, widget.userProfile.id)
                .catchError((err, stack) {
              if (mounted) {
                context.showErrorSnackBar(message: err.toString());
              }
            });
            ref.invalidate(friendsIdsProvider);
          },
        )
      ];
    }

    return [
      ProfileAction(
        title: const Text('Zaproś do znajomych'),
        icon: const Icon(Icons.person_add),
        onTap: () async {
          await FriendshipsDB.sendFriendRequest(
                  supabase.auth.currentUser!.id, widget.userProfile.id)
              .catchError((err, stack) {
            if (mounted) {
              context.showErrorSnackBar(message: err.toString());
            }
          });
          ref.invalidate(friendsIdsProvider);
        },
      )
    ];
  }
}
