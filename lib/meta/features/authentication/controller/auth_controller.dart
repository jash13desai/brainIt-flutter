import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/meta/features/authentication/repository/auth_repository.dart';
import 'package:reddit/meta/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepo: ref.watch(authRepoProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepo _authRepo;
  final Ref _ref;
  AuthController({required AuthRepo authRepo, required Ref ref})
      : _authRepo = authRepo,
        _ref = ref,
        super(false); // isLoading

  Stream<User?> get authStateChange => _authRepo.authStateChange;

  void signInWithGoogle(BuildContext ctx, bool isFromLogin) async {
    state = true;
    final user = await _authRepo.signInWithGoogle(isFromLogin);
    state = false;
    // l --> failure : r --> success
    user.fold(
      (l) => showSnackBar(ctx, l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepo.signInAsGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepo.getUserData(uid);
  }

  void logOut() async {
    _authRepo.logOut();
  }
}
