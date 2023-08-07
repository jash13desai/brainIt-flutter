// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  final String communityName;
  const ModToolsScreen({
    super.key,
    required this.communityName,
  });
  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$communityName');
  }

  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$communityName');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator_rounded),
            title: const Text('Add Moderators'),
            onTap: () => navigateToAddMods(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text('Edit Community'),
            onTap: () => navigateToEditCommunity(context),
          )
        ],
      ),
    );
  }
}
