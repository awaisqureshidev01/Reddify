import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/comment_model.dart';
import '../../../responsive/responsive.dart';
import '../../post/controller/post_controller.dart';
import '../../post/widget/comment_card.dart';

class NestedCommentScreen extends ConsumerStatefulWidget {
  final String commentId;
  const NestedCommentScreen({super.key, required this.commentId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NestedCommentScreenState();
}

class _NestedCommentScreenState extends ConsumerState<NestedCommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  void replyToComment(Comment comment) {
    ref.read(postControllerProvider.notifier).replyToComment(
          context: context,
          text: commentController.text.trim(),
          parentId: comment.id,
          postId: comment.postId,
        );
    // commentController.clear;
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // final comment = ref.watch(getCommentByIdProvider(widget.commentId));
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getCommentByIdProvider(widget.commentId)).when(
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommentCard(comment: data),
                Responsive(
                  child: TextField(
                    onSubmitted: (val) => replyToComment(data),
                    controller: commentController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'What are your thoughts?',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ref.watch(getNestedCommentsProvider(widget.commentId)).when(
                    data: (data) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final comment = data[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 4)
                                    .copyWith(right: 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                comment.profilePic),
                                            radius: 18,
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'u/${comment.username}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(comment.text),
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    ]),
                              );
                            }),
                      );
                    },
                    error: (error, stackTrace) {
                      print(error.toString());
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader())
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
