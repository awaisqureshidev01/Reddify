// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../../models/community_model.dart';
import '../../auth/controller/auth.controller.dart';
import '../controller/community_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({
    super.key,
    required this.name,
  });

  void joinComunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsSelected) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                            child: Image.network(
                          community.banner,
                          fit: BoxFit.cover,
                        )),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(60),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                          radius: 35,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'r/${community.name}',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!isGuest)
                            community.mods.contains(user.uid)
                                ? OutlinedButton(
                                    onPressed: () {
                                      navigateToModTools(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                    ),
                                    child: const Text('Mod Tools'),
                                  )
                                : OutlinedButton(
                                    onPressed: () =>
                                        joinComunity(ref, community, context),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                    ),
                                    child: Text(
                                        community.members.contains(user.uid)
                                            ? 'Joined'
                                            : 'Join'),
                                  )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '${community.members.length} members',
                        ),
                      )
                    ])),
                  )
                ];
              },
              body: ref.watch(getCommunityPostProvider(name)).when(
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
                  loading: () => const Loader())),
          error: (error, StackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
