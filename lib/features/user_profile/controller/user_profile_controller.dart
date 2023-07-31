import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/enums/enums.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth.controller.dart';
import '../repository/user_profile_repository.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final communityRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
      userProfileRepository: communityRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController(
      {required UserProfileRepository userProfileRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editCommunity({
    required File? bannerFile,
    required File? profileFile,
    required Uint8List? bannerWebFile,
    required Uint8List? profileWebFile,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null || profileWebFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/profile',
          id: user.uid,
          file: profileFile,
          webFile: profileWebFile);
      res.fold((l) => showSnackBar(context, l.message),
          (profileFile) => user = user.copyWith(profilePic: profileFile));
    }

    if (bannerFile != null || bannerWebFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/banner',
          id: user.uid,
          file: bannerFile,
          webFile: bannerWebFile);
      res.fold((l) => showSnackBar(context, l.message),
          (bannerFile) => user = user.copyWith(banner: bannerFile));
    }

    user = user.copyWith(name: name);

    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);

    final res = await _userProfileRepository.updateUSerKarma(user);
    res.fold((l) => null,
        (r) => _ref.read(userProvider.notifier).update((state) => user));
  }
}
