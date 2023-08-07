import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/responsive/responsive.dart';
import 'package:reddit/core/theme/pallete.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({super.key, this.isFromLogin = true});

  void signInWithGoogle(BuildContext ctx, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(ctx, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Responsive(
          child: Text(
            "Continue with Google",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
