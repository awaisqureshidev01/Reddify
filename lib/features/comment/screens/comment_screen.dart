import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../../models/post_model.dart';
import '../../../responsive/responsive.dart';
import '../../auth/controller/auth.controller.dart';
import '../../post/controller/post_controller.dart';
import '../../post/widget/comment_card.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ComementScreenState();
}

class _ComementScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
        context: context, text: commentController.text.trim(), post: post);
    // commentController.clear;
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostCard(post: data),
                if (!isGuest)
                  Responsive(
                    child: TextField(
                      onSubmitted: (val) => addComment(data),
                      controller: commentController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'What are your thoughts?',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ref.watch(getPostCommentsProvider(widget.postId)).when(
                    data: (data) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final comment = data[index];
                              return CommentCard(comment: comment);
                            }),
                      );
                    },
                    error: (error, stackTrace) {
                      print(error);
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader()),
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
