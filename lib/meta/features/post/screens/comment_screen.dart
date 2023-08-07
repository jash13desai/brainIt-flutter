import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/responsive/responsive.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/features/post/controller/post_controller.dart';
import 'package:reddit/meta/features/post/widgets/comment_card.dart';
import 'package:reddit/meta/models/post_model.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';
import 'package:reddit/meta/shared/post_card.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(PostModel post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = user.isGuest;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return Column(
                children: [
                  PostCard(post: post),
                  if (!isGuest)
                    Responsive(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          onSubmitted: (val) => addComment(post),
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: 'What are your thoughts?',
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (data) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final comment = data[index];
                                  return CommentCard(comment: comment);
                                },
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) {
                          return ErrorText(
                            error: error.toString(),
                          );
                        },
                        loading: () => const Loader(),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
