// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/features/community/controller/community_controller.dart';
import 'package:reddit/meta/models/community_model.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';
import 'package:reddit/meta/shared/post_card.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({
    super.key,
    required this.name,
  });

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(
      BuildContext context, WidgetRef ref, CommunityModel community) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = user.isGuest;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) => NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              community.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(18),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 35,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'r/${community.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                                if (!isGuest)
                                  community.mods.contains(user.uid)
                                      ? OutlinedButton(
                                          onPressed: () =>
                                              navigateToModTools(context),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            visualDensity: const VisualDensity(
                                              horizontal: 1.35,
                                              vertical: 0.6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 25,
                                            ),
                                          ),
                                          child: const Text(
                                            'Mod Tools',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      : OutlinedButton(
                                          onPressed: () => joinCommunity(
                                              context, ref, community),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            visualDensity: const VisualDensity(
                                              horizontal: 1.35,
                                              vertical: 0.6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 25,
                                            ),
                                          ),
                                          child: Text(
                                            community.members.contains(user.uid)
                                                ? 'Joined'
                                                : 'Join',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child:
                                  Text('${community.members.length}  members'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: ref.watch(getCommunityPostsProvider(community.name)).when(
                      data: (data) {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = data[index];
                            return PostCard(post: post);
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        return ErrorText(error: error.toString());
                      },
                      loading: () => const Loader(),
                    )),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
