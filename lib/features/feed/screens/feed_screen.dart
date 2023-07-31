import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../auth/controller/auth.controller.dart';
import '../../community/controller/community_controller.dart';
import '../../post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    if (!isGuest) {
      return ref.watch(userCommunityProvider).when(
          data: (community) => ref.watch(userPostsProvider(community)).when(
              data: (posts) {
                return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = posts[index];
                      return PostCard(
                        post: post,
                      );
                    });
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader()),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader());
    }

    return ref.watch(userCommunityProvider).when(
        data: (community) => ref.watch(guestPostsProvider).when(
            data: (posts) {
              return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                    );
                  });
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader()),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
