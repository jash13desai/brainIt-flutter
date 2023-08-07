// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/theme/pallete.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/meta/features/community/controller/community_controller.dart';
import 'package:reddit/meta/models/community_model.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';

// import 'package:routemaster/routemaster.dart';
class EditCommunityScreen extends ConsumerStatefulWidget {
  final String communityName;
  const EditCommunityScreen({
    super.key,
    required this.communityName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
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

  void saveCommunityEdits(CommunityModel community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          context: context,
          avatarImage: avatarImage,
          bannerImage: bannerImage,
          community: community,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return !isLoading
        ? ref.watch(getCommunityByNameProvider(widget.communityName)).when(
              data: (community) => Scaffold(
                backgroundColor: currentTheme.backgroundColor,
                appBar: AppBar(
                  title: const Text('Edit Commnunity'),
                  actions: [
                    TextButton(
                      onPressed: () => saveCommunityEdits(community),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
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
                                color: currentTheme.textTheme.bodyText2!.color!,
                                strokeWidth: 2,
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: bannerImage == null
                                      ? community.banner.isEmpty ||
                                              community.banner ==
                                                  Constants.bannerDefault
                                          ? const Center(
                                              child: Icon(
                                                Icons.add_a_photo_outlined,
                                                size: 40,
                                              ),
                                            )
                                          : Center(
                                              child: Image.network(
                                                  community.banner))
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
                                          NetworkImage(community.avatar),
                                      radius: 27,
                                    )
                                  : CircleAvatar(
                                      backgroundImage: FileImage(avatarImage!),
                                      radius: 27,
                                    ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            )
        : const Loader();
  }
}
