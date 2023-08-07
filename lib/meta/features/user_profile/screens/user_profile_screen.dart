// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';
import 'package:reddit/meta/shared/post_card.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  void navToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            user.profileBanner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding:
                              const EdgeInsets.all(20).copyWith(bottom: 70),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profileAvatar),
                            radius: 35,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20),
                          child: OutlinedButton(
                            onPressed: () => navToEditProfile(context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
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
                              'Edit Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(18),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'u/${user.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('${user.karma}  Karma'),
                          ),
                          const SizedBox(height: 20),
                          const Divider(thickness: 2.25),
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: ref.watch(getUserPostsProvider(uid)).when(
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
                  ),
            ),
            error: (error, stackTrace) {
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
