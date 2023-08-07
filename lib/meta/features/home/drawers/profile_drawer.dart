import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/theme/pallete.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  void navToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profileAvatar),
              radius: 70,
            ),
            const SizedBox(height: 15),
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Divider(thickness: 1),
            ),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () => navToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => logOut(ref),
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (val) => toggleTheme(ref),
            ),
          ],
        ),
      ),
    );
  }
}
