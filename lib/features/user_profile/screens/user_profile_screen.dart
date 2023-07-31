import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../auth/controller/auth.controller.dart';
import '../controller/user_profile_controller.dart';

class UserProfileScreen extends ConsumerWidget {
  String uid;
  UserProfileScreen({super.key, required this.uid});

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
          data: (user) => NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsSelected) {
                  return [
                    SliverAppBar(
                      expandedHeight: 250,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                              child: Image.network(
                            user.banner,
                            fit: BoxFit.cover,
                          )),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding:
                                const EdgeInsets.all(20).copyWith(bottom: 70),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 45,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () => navigateToEditUser(context),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: Text('Edit Profile'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(60),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'u/${user.name}',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            '${user.karma} karma',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 2,
                        ),
                      ])),
                    )
                  ];
                },
                body: ref.watch(getUserPostsProvider(uid)).when(
                    data: (data) {
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final post = data[index];
                            return PostCard(
                              post: post,
                            );
                          });
                    },
                    error: (error, stackTrace) {
                      print(error.toString());
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader()),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
