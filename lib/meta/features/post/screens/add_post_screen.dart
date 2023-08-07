// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navToTypeScreen(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = 120;
    double iconSize = 60;
    final currentTheme = ref.watch(themeNotifierProvider);
    final flag =
        ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.light;
    final cardColor = flag ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: cardHeightWidth * 2.75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: currentTheme.colorScheme.background,
                      spreadRadius: 1,
                    ),
                  ],
                  color: cardColor),
              child: GestureDetector(
                onTap: () => navToTypeScreen(context, 'image'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: cardHeightWidth,
                      width: cardHeightWidth,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: currentTheme.colorScheme.background,
                        elevation: 16,
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Post an Image!",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
            Container(
              width: cardHeightWidth * 2.75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: currentTheme.colorScheme.background,
                      spreadRadius: 1,
                    ),
                  ],
                  color: cardColor),
              child: GestureDetector(
                onTap: () => navToTypeScreen(context, 'text'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: cardHeightWidth,
                      width: cardHeightWidth,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: currentTheme.colorScheme.background,
                        elevation: 16,
                        child: Center(
                          child: Icon(
                            Icons.font_download_outlined,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Post a Text!",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
            Container(
              width: cardHeightWidth * 2.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: currentTheme.colorScheme.background,
                    spreadRadius: 1,
                  ),
                ],
                color: cardColor,
              ),
              child: GestureDetector(
                onTap: () => navToTypeScreen(context, 'link'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: cardHeightWidth,
                      width: cardHeightWidth,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: currentTheme.colorScheme.background,
                        child: Center(
                          child: Icon(
                            Icons.link_outlined,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Post a Link!",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
