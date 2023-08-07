import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reddit/core/enums/enums.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:reddit/meta/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/providers/storage_repo_provider.dart';
import 'package:reddit/meta/features/user_profile/repository/user_profile_repository.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
  (ref) {
    final userProfileRepo = ref.watch(userProfileRepoProvider);
    final storageRepo = ref.watch(storageRepoProvider);
    return UserProfileController(
      userProfileRepo: userProfileRepo,
      storageRepo: storageRepo,
      ref: ref,
    );
  },
);

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepo _userProfileRepo;
  final Ref _ref;
  final StorageRepo _storageRepo;
  UserProfileController({
    required UserProfileRepo userProfileRepo,
    required Ref ref,
    required StorageRepo storageRepo,
  })  : _userProfileRepo = userProfileRepo,
        _ref = ref,
        _storageRepo = storageRepo,
        super(false);

  void editUserProfile({
    required BuildContext context,
    required File? avatarImage,
    required File? bannerImage,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (avatarImage != null) {
      final res = await _storageRepo.storeFile(
        path: 'users/profileAvatar',
        id: user.uid,
        file: avatarImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profileAvatar: r),
      );
    }
    if (bannerImage != null) {
      final res = await _storageRepo.storeFile(
        path: 'users/profileBanner',
        id: user.uid,
        file: bannerImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profileBanner: r),
      );
    }
    user = user.copyWith(name: name);
    final res = await _userProfileRepo.editUserProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        showSnackBar(context, 'Profile changes successful!');
        Routemaster.of(context).pop();
      },
    );
  }

  void updateUserKarma(UserKarma userKarma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + userKarma.karma);

    final res = await _userProfileRepo.updateUserKarma(user);
    res.fold(
      (l) => null,
      (r) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }

  Stream<List<PostModel>> getUserPosts(String uid) {
    return _userProfileRepo.getUserPosts(uid);
  }
}
