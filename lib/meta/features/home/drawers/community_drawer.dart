import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/theme/pallete.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/features/community/controller/community_controller.dart';
import 'package:reddit/meta/models/community_model.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';
import 'package:reddit/meta/shared/sign_in_button.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});
  void navToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navToCommunity(BuildContext context, CommunityModel communityModel) {
    Routemaster.of(context).push('/r/${communityModel.name}');
  }

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = user.isGuest;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? Column(
                    children: [
                      const SignInButton(),
                      ListTile(
                        title: const Text('Log Out'),
                        leading: Icon(
                          Icons.logout,
                          color: Pallete.redColor,
                        ),
                        onTap: () => logOut(ref),
                      ),
                    ],
                  )
                : ListTile(
                    title: const Text('Create a community'),
                    leading: const Icon(Icons.add),
                    onTap: () => navToCreateCommunity(context),
                  ),
            if (!isGuest)
              ref.watch(userCommunitiesProvider).when(
                    data: (communities) => Expanded(
                      child: ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (BuildContext context, int idx) {
                          final community = communities[idx];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            title: Text("r/${community.name}"),
                            onTap: () => navToCommunity(context, community),
                          );
                        },
                      ),
                    ),
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
          ],
        ),
      ),
    );
  }
}
