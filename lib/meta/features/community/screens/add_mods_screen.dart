// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/meta/features/authentication/controller/auth_controller.dart';
import 'package:reddit/meta/features/community/controller/community_controller.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String communityName;
  const AddModsScreen({
    super.key,
    required this.communityName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int modsCount = 0;
  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveModsChanges() {
    ref.read(communityControllerProvider.notifier).addMods(
          context,
          widget.communityName,
          uids.toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveModsChanges,
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.communityName)).when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (BuildContext context, int idx) {
                final member = community.members[idx];
                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member)) {
                          uids.add(member);
                        }
                        modsCount++;
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUids(user.uid);
                            } else {
                              removeUids(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    );
              },
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
