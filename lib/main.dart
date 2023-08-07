import 'package:firebase_auth/firebase_auth.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';
import 'package:reddit/routes.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/pallete.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'meta/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  void getData(WidgetRef ref, User user) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(user.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'BrainIt App',
            theme: ref.watch(themeNotifierProvider),
            // home: const LoginScreen(),
            routerDelegate: RoutemasterDelegate(routesBuilder: (ctx) {
              if (data != null) {
                getData(ref, data);
                if (userModel != null) return loggedInRoute;
              }
              return loggedOutRoute;
            }),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
