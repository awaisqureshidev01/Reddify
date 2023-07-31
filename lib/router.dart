import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'features/comment/screens/comment_screen.dart';
import 'features/comment/screens/nested_comment_screen.dart';
import 'features/community/screens/add_mods_screen.dart';
import 'features/community/screens/community_screen.dart';
import 'features/community/screens/create_community.dart';
import 'features/community/screens/edit_community.dart';
import 'features/community/screens/mod_tools_screeen.dart';
import 'features/home/home_screen.dart';
import 'features/post/screens/add_post_screen.dart';
import 'features/post/screens/add_post_type_screen.dart';
import 'features/screens/login_screen.dart';
import 'features/user_profile/screens/edit_profile_screen.dart';
import 'features/user_profile/screens/user_profile_screen.dart';

final loddedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunity()),
  '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
        name: route.pathParameters['name']!,
      )),
  '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModtoolsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunity(
        name: routeData.pathParameters['name']!,
      )),
  '/add-mods/:name': (routeData) => MaterialPage(
          child: AddModsScreen(
        name: routeData.pathParameters['name']!,
      )),
  '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
        uid: routeData.pathParameters['uid']!,
      )),
  '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(
        uid: routeData.pathParameters['uid']!,
      )),
  '/add-post/:type': (routeData) => MaterialPage(
          child: AddPostTypeScreen(
        type: routeData.pathParameters['type']!,
      )),
  '/post/:postId/comments': (routeData) => MaterialPage(
          child: CommentScreen(
        postId: routeData.pathParameters['postId']!,
      )),
  '/add-post': (routeData) => const MaterialPage(child: AddPostScreen()),
  '/posts/:commentId': (routeData) => MaterialPage(
          child: NestedCommentScreen(
        commentId: routeData.pathParameters['commentId']!,
      )),
});
