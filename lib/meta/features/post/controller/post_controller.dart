import 'dart:io';
import 'package:reddit/core/enums/enums.dart';
import 'package:reddit/meta/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/meta/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:reddit/core/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:routemaster/routemaster.dart';
import 'package:reddit/meta/models/post_model.dart';
import 'package:reddit/meta/models/comment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/meta/models/community_model.dart';
import 'package:reddit/core/providers/storage_repo_provider.dart';
import 'package:reddit/meta/features/post/repository/post_repository.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepo = ref.watch(postRepoProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return PostController(
    postRepo: postRepo,
    storageRepo: storageRepo,
    ref: ref,
  );
});

final userPostsProvider =
    StreamProvider.family((ref, List<CommunityModel> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final guestPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPosts();
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepo _postRepo;
  final Ref _ref;
  final StorageRepo _storageRepo;
  PostController({
    required PostRepo postRepo,
    required Ref ref,
    required StorageRepo storageRepo,
  })  : _postRepo = postRepo,
        _ref = ref,
        _storageRepo = storageRepo,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepo.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepo.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required File? file,
    required Uint8List? webFile,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepo.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: file,
      // webFile: webFile,
    );

    imageRes.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        final PostModel post = PostModel(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r,
        );

        final res = await _postRepo.addPost(post);
        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.imagePost);
        state = false;
        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            showSnackBar(context, 'Posted successfully!');
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<PostModel>> fetchUserPosts(List<CommunityModel> communities) {
    if (communities.isNotEmpty) {
      return _postRepo.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<PostModel>> fetchGuestPosts() {
    return _postRepo.fetchGuestPosts();
  }

  void deletePost(PostModel post, BuildContext context) async {
    final res = await _postRepo.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);
    res.fold((l) => null,
        (r) => showSnackBar(context, 'Post Deleted successfully!'));
  }

  void upvote(PostModel post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepo.upvote(post, uid);
  }

  void downvote(PostModel post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepo.downvote(post, uid);
  }

  Stream<PostModel> getPostById(String postId) {
    return _postRepo.getPostById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required PostModel post,
  }) async {
    UserModel user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();
    CommentModel comment = CommentModel(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      profilePic: user.profileAvatar,
      username: user.name,
      uid: user.uid,
    );
    final res = await _postRepo.addComment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  void awardPost({
    required PostModel post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepo.awardPost(post, award, user.uid);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.awardPost);
        _ref.read(userProvider.notifier).update((state) {
          state?.awards.remove(award);
          return state;
        });
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<CommentModel>> fetchPostComments(String postId) {
    return _postRepo.getCommentsOfPost(postId);
  }
}
