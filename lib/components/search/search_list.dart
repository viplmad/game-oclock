import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ListReloaded, ListSearchChanged, SearchListBloc;
import 'package:game_oclock/components/list/grid_list.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/components/show_form_dialog.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, SearchDTO;
import 'package:game_oclock/utils/localisation_extension.dart';

import 'search_form.dart';

class SearchListPage extends StatelessWidget {
  const SearchListPage({super.key, required this.space});

  final String space;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SearchListBloc(space: space, service: RepositoryProvider.of(context))
            ..add(ListSearchChanged(search: SearchDTO())),
      // TODO create button
      child: GridListBuilder<ListSearch, SearchListBloc>(
        itemAspectRatio: 3.5,
        columns: (MediaQuery.sizeOf(context).width / 600).ceil(),
        itemBuilder: (final context, final data, final index) =>
            SearchGridListItem(space: space, data: data),
      ),
    );
  }
}

class SearchGridListItem extends StatelessWidget {
  const SearchGridListItem({
    super.key,
    required this.space,
    required this.data,
  });

  final String space;
  final ListSearch data;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      hasImage: false,
      title: data.name,
      onTap: () {
        Navigator.pop(context, data);
      },
      trailing: IconButton(
        icon: CommonIcons.edit,
        tooltip: context.localize().editLabel,
        onPressed: () async => showFormDialog<ListSearch>(
          context,
          builder: (final context) =>
              SearchEditForm(space: space, name: data.name),
          onSuccess: (final context, _) =>
              context.read<SearchListBloc>().add(const ListReloaded()),
        ),
      ),
    );
  }
}
