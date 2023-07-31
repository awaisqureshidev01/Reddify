import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';
import '../repositories/auth_repository.dart';

//You can use this provider to access the current user information from anywhere in your app by reading its state.

final userProvider = StateProvider<UserModel?>((ref) => null);

//You can use this provider to perform authentication-related operations,
//such as signing in, signing out, etc. The AuthController class is responsible for handling these operations.

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(AuthRepositoryProvider), ref: ref));

//You can use this provider to monitor the authentication state in real-time.
// It provides a stream of authentication state changes, which can be accessed by reading its value.

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);

  return authController.authStateChange;
});

//You can use this provider to fetch user data for a specific user ID.
// It returns a stream of UserModel representing the user's data.

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);

  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChanged;

  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    state = true;
    final user = await _authRepository.signInWithGoogle(isFromLogin);
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout() async {
    _authRepository.logout();
  }
}
