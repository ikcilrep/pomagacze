import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/profile_action.dart';
import 'package:pomagacze/components/user_profile_details.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/activity.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/pages/event_details.dart';
import 'package:pomagacze/state/activities.dart';
import 'package:pomagacze/state/friendships.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/date_extensions.dart';
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

    final friendIds = ref.watch(friendsIdsProvider);
    final outgoingFriendRequests = ref.watch(outgoingFriendRequestsProvider);
    final incomingFriendRequests = ref.watch(incomingFriendRequestsProvider);
    final userActivities =
        ref.watch(userActivitiesProvider(widget.userProfile.id));

    if (friendIds.valueOrNull?.contains(widget.userProfile.id) == true) {
      return [
        ExpansionTile(title: const Text("Ostatnie wydarzenia"), children: [
          userActivities.when(
              data: _buildUserActivities,
              error: (err, stack) =>
                  Center(child: Text('Coś poszło nie tak: $err')),
              loading: () => const Center(child: CircularProgressIndicator()))
        ]),
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

  Widget _buildUserActivities(List<Activity> activities) {
    activities.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (BuildContext context, int index) {
        return OpenContainer<bool>(
            tappable: true,
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: const Duration(milliseconds: 350),
            openBuilder: (BuildContext context, VoidCallback _) =>
                EventDetails(activities[index].event),
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            closedElevation: 1.5,
            // transitionDuration: const Duration(seconds: 2),
            closedBuilder: (_, openContainer) => ListTile(
                  title: Text(activities[index].event.title),
                  subtitle: Text(
                      "Dołączono ${activities[index].createdAt.displayable()}"),
                ));
      },
    );
  }
}
