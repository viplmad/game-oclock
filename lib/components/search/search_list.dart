import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ListLoaded, ListReloaded, SearchListBloc;
import 'package:game_oclock/components/list/grid_list.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, SearchDTO;

import 'search_form.dart';

class SearchListPage extends StatelessWidget {
  const SearchListPage({super.key, required this.space});

  final String space;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (_) => SearchListBloc(space: space)
        ..add(
          ListLoaded(
            search: ListSearch(name: 'default', search: SearchDTO()),
          ),
        ),
      child: GridListBuilder<ListSearch, SearchListBloc>(
        space: '', // Empty space because search cannot be filtered
        itemBuilder: (final context, final data, final index) => TileListItem(
          title: data.name,
          onTap: () {
            Navigator.pop(context, data);
          },
          trailing: IconButton(
            icon: const Icon(CommonIcons.edit),
            onPressed: () async =>
                showDialog<bool>(
                  context: context,
                  builder: (final context) =>
                      SearchEditForm(space: space, name: data.name),
                ).then((final bool? success) {
                  if (success != null && success && context.mounted) {
                    context.read<SearchListBloc>().add(const ListReloaded());
                  }
                }),
          ),
        ),
      ),
    );
  }
}
