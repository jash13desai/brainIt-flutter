import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/type_def.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/meta/models/post_model.dart';
import 'package:reddit/meta/models/user_model.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/providers/firebase_providers.dart';

final userProfileRepoProvider = Provider((ref) {
  return UserProfileRepo(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepo {
  final FirebaseFirestore _firestore;
  UserProfileRepo({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid editUserProfile(UserModel user) async {
    try {
      return right(
        _users.doc(user.uid).update(user.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> getUserPosts(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
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

  FutureVoid updateUserKarma(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update({
        'karma': user.karma,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(FireBaseConst.usersCollection);
  CollectionReference get _posts =>
      _firestore.collection(FireBaseConst.postsCollection);
}
