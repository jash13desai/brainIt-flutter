import 'package:flutter/material.dart';
import 'package:reddit/meta/features/community/screens/add_mods_screen.dart';
import 'package:reddit/meta/features/community/screens/community_screen.dart';
import 'package:reddit/meta/features/community/screens/mod_tools_screen.dart';
import 'package:reddit/meta/features/home/screens/home_screen.dart';
import 'package:reddit/meta/features/post/screens/add_post_type_screen.dart';
import 'package:reddit/meta/features/post/screens/comment_screen.dart';
import 'package:reddit/meta/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:reddit/meta/features/authentication/screens/login.screen.dart';

import 'meta/features/community/screens/create_commuity_screen.dart';
import 'meta/features/community/screens/edit_community_screen.dart';
import 'meta/features/user_profile/screens/edit_profile_screen.dart';

// loggedOut
final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

// loggedIn
final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(name: route.pathParameters['name']!),
        ),
    '/mod-tools/:name': (route) => MaterialPage(
          child: ModToolsScreen(communityName: route.pathParameters['name']!),
        ),
    '/edit-community/:name': (route) => MaterialPage(
          child:
              EditCommunityScreen(communityName: route.pathParameters['name']!),
        ),
    '/add-mods/:name': (route) => MaterialPage(
          child: AddModsScreen(communityName: route.pathParameters['name']!),
        ),
    '/u/:uid': (route) => MaterialPage(
          child: UserProfileScreen(uid: route.pathParameters['uid']!),
        ),
    '/edit-profile/:uid': (route) => MaterialPage(
          child: EditProfileScreen(uid: route.pathParameters['uid']!),
        ),
    '/add-post/:type': (route) => MaterialPage(
          child: AddPostTypeScreen(type: route.pathParameters['type']!),
        ),
    '/post/:postId/comments': (route) => MaterialPage(
          child: CommentsScreen(
            postId: route.pathParameters['postId']!,
          ),
        ),
  },
);
