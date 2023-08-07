import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/meta/features/community/controller/community_controller.dart';
import 'package:reddit/meta/models/community_model.dart';
import 'package:reddit/meta/shared/error_text.dart';
import 'package:reddit/meta/shared/loader.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate(this.ref);
  void navToCommunity(BuildContext context, CommunityModel communityModel) {
    Routemaster.of(context).push('/r/${communityModel.name}');
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
          data: (communities) => ListView.builder(
            itemCount: communities.length,
            itemBuilder: (BuildContext context, int idx) {
              final community = communities[idx];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.avatar),
                ),
                title: Text('r/${community.name}'),
                onTap: () => navToCommunity(context, community),
              );
            },
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
