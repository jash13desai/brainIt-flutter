import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/features/community/controller/community_controller.dart';
import 'package:reddit/meta/features/post/controller/post_controller.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';
import 'package:reddit/meta/shared/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = user.isGuest;

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
            data: (communities) =>
                ref.watch(userPostsProvider(communities)).when(
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
                        return ErrorText(
                          error: error.toString(),
                        );
                      },
                      loading: () => const Loader(),
                    ),
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          );
    } else {
      return ref.watch(userCommunitiesProvider).when(
            data: (communities) => ref.watch(guestPostsProvider).when(
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
                    return ErrorText(
                      error: error.toString(),
                    );
                  },
                  loading: () => const Loader(),
                ),
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          );
    }
  }
}
