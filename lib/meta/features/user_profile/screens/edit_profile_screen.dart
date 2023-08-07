// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/theme/pallete.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  const EditProfileScreen({
    required this.uid,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  File? bannerImage;
  void chooseBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerImage = File(res.files.last.path!);
      });
    }
  }

  File? avatarImage;
  void chooseAvatarImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        avatarImage = File(res.files.last.path!);
      });
    }
  }

  void saveProfileEdits() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
          context: context,
          avatarImage: avatarImage,
          bannerImage: bannerImage,
          name: nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            backgroundColor: currentTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                TextButton(
                  onPressed: saveProfileEdits,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                              child: GestureDetector(
                                onTap: chooseBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(20),
                                  dashPattern: const [9, 9],
                                  strokeCap: StrokeCap.round,
                                  color:
                                      currentTheme.textTheme.bodyText2!.color!,
                                  strokeWidth: 2,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: bannerImage == null
                                        ? user.profileBanner.isEmpty ||
                                                user.profileBanner ==
                                                    Constants.bannerDefault
                                            ? const Center(
                                                child: Icon(
                                                  Icons.add_a_photo_outlined,
                                                  size: 40,
                                                ),
                                              )
                                            : Center(
                                                child: Image.network(
                                                    user.profileBanner),
                                              )
                                        : Image.file(bannerImage!),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 35,
                              bottom: 20,
                              child: GestureDetector(
                                onTap: chooseAvatarImage,
                                child: avatarImage == null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(user.profileAvatar),
                                        radius: 27,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            FileImage(avatarImage!),
                                        radius: 27,
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
