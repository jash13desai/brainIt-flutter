import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/responsive/responsive.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/shared/loader.dart';
import 'package:reddit/meta/shared/sign_in_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.iconPath,
          height: 50,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => signInAsGuest(ref, context),
            child: const Text(
              "Skip",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Dive into anything',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      Constants.logoPath,
                      height: 450,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Responsive(child: SignInButton()),
                ],
              ),
            ),
    );
  }
}
