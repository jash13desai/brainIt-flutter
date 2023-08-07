import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/type_def.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/meta/models/community_model.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/meta/models/post_model.dart';

final communityRepoProvider = Provider((ref) {
  return CommunityRepo(firestore: ref.watch(firestoreProvider));
});

class CommunityRepo {
  final FirebaseFirestore _firestore;
  CommunityRepo({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(CommunityModel communityModel) async {
    try {
      var communityDoc = await _communities.doc(communityModel.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists.';
      }
      return right(
        _communities.doc(communityModel.name).set(communityModel.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(CommunityModel community, String uid) async {
    try {
      return right(
        _communities.doc(community.name).update(
          {
            'members': FieldValue.arrayUnion([uid])
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(CommunityModel community, String uid) async {
    try {
      return right(
        _communities.doc(community.name).update(
          {
            'members': FieldValue.arrayRemove([uid])
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var doc in event.docs) {
        communities.add(
          CommunityModel.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      return communities;
    });
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
          (event) =>
              CommunityModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid editCommunity(CommunityModel community) async {
    try {
      return right(
        _communities.doc(community.name).update(community.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'mods': uids,
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommunityModel>> searchCommunity(String searchQuery) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: searchQuery.isEmpty ? 0 : searchQuery,
          isLessThan: searchQuery.isEmpty
              ? null
              : searchQuery.substring(0, searchQuery.length) +
                  String.fromCharCode(
                      searchQuery.codeUnitAt(searchQuery.length - 1) + 1),
        )
        .snapshots()
        .map(
      (event) {
        List<CommunityModel> communities = [];
        for (var community in event.docs) {
          communities.add(
            CommunityModel.fromMap(community.data() as Map<String, dynamic>),
          );
        }
        return communities;
      },
    );
  }

  Stream<List<PostModel>> getCommunityPosts(String communityName) {
    return _posts
        .where('communityName', isEqualTo: communityName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => PostModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  CollectionReference get _communities =>
      _firestore.collection(FireBaseConst.communitiesCollection);

  CollectionReference get _posts =>
      _firestore.collection(FireBaseConst.postsCollection);
}
