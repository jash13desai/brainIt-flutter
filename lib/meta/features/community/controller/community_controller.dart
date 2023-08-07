import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/storage_repo_provider.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/features/community/repository/community_repository.dart';
import 'package:reddit/meta/models/community_model.dart';
import 'package:reddit/meta/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider(
  (ref) {
    final communityController = ref.watch(communityControllerProvider.notifier);
    return communityController.getUserCommunities();
  },
);

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>(
  (ref) {
    final communityRepo = ref.watch(communityRepoProvider);
    final storageRepo = ref.watch(storageRepoProvider);
    return CommunityController(
      communityRepo: communityRepo,
      ref: ref,
      storageRepo: storageRepo,
    );
  },
);

final getCommunityByNameProvider = StreamProvider.family(
  (ref, String name) {
    return ref
        .watch(communityControllerProvider.notifier)
        .getCommunityByName(name);
  },
);

final searchCommunityProvider =
    StreamProvider.family((ref, String searchQuery) {
  return ref
      .watch(communityControllerProvider.notifier)
      .searchCommunity(searchQuery);
});

final getCommunityPostsProvider =
    StreamProvider.family((ref, String communityName) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityPosts(communityName);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepo _communityRepo;
  final Ref _ref;
  final StorageRepo _storageRepo;
  CommunityController({
    required CommunityRepo communityRepo,
    required Ref ref,
    required StorageRepo storageRepo,
  })  : _communityRepo = communityRepo,
        _ref = ref,
        _storageRepo = storageRepo,
        super(false);

  void createCommunity(
    String communityName,
    BuildContext context,
  ) async {
    state = true;
    final uid = _ref.read(userProvider)!.uid;
    CommunityModel communityModel = CommunityModel(
      id: communityName,
      name: communityName,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final result = await _communityRepo.createCommunity(communityModel);
    state = false;
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Community created successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  void joinCommunity(CommunityModel community, BuildContext context) async {
    final String uid = _ref.watch(userProvider)!.uid;
    bool isMember = community.members.contains(uid);
    Either<Failure, void> res;
    if (isMember) {
      res = await _communityRepo.leaveCommunity(community, uid);
    } else {
      res = await _communityRepo.joinCommunity(community, uid);
    }
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => isMember
          ? showSnackBar(context, 'Community left successfully!')
          : showSnackBar(context, 'Community joined successfully!'),
    );
  }

  void editCommunity({
    required BuildContext context,
    required File? avatarImage,
    required File? bannerImage,
    required CommunityModel community,
  }) async {
    if (avatarImage != null) {
      state = true;
      final res = await _storageRepo.storeFile(
        path: 'communities/avatar',
        id: community.name,
        file: avatarImage,
      );
      state = false;
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }
    if (bannerImage != null) {
      state = true;
      final res = await _storageRepo.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerImage,
      );
      state = false;
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res = await _communityRepo.editCommunity(community);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void addMods(BuildContext context, community, List<String> uids) async {
    final res = await _communityRepo.addMods(community, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Moderators changed successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<CommunityModel>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepo.getUserCommunities(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepo.getCommunityByName(name);
  }

  Stream<List<CommunityModel>> searchCommunity(String searchQuery) {
    return _communityRepo.searchCommunity(searchQuery);
  }

  Stream<List<PostModel>> getCommunityPosts(String communityName) {
    return _communityRepo.getCommunityPosts(communityName);
  }
}
