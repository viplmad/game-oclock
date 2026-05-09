import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ListReloaded, ListSearchChanged, SearchListBloc;
import 'package:game_oclock/components/list/grid_list.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/components/list/toolbar.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';

import 'search_form.dart';

class SearchListPage extends StatelessWidget {
  const SearchListPage({
    super.key,
    required this.space,
    required this.currentSearch,
  });

  final String space;
  final ListSearch currentSearch;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SearchListBloc(service: RepositoryProvider.of(context), space: space)
            ..add(ListSearchChanged(search: ListSearchDTO())),
      child: _SearchListBuilder(space: space, currentSearch: currentSearch),
    );
  }
}

class _SearchListBuilder extends StatelessWidget {
  const _SearchListBuilder({required this.space, required this.currentSearch});

  final String space;
  final ListSearch currentSearch;

  @override
  Widget build(final BuildContext context) {
    return ListLayout(
      toolbar: ListToolbar(
        actions: [
          IconButton(
            icon: CommonIcons.add,
            tooltip: context.localize().createLabel,
            onPressed: () async => showReturningDialog(
              context,
              builder: (final context) => SearchCreateForm(space: space),
              onSuccess: (final context, _) =>
                  context.read<SearchListBloc>().add(const ListReloaded()),
            ),
          ),
          IconButton(
            icon: CommonIcons.reload,
            tooltip: context.localize().reloadLabel,
            onPressed: () =>
                context.read<SearchListBloc>().add(const ListReloaded()),
          ),
        ],
      ),
      statusbar: const ListTotalStatusbarBuilder<ListSearch, SearchListBloc>(),
      child: GridListBuilder<ListSearch, SearchListBloc>(
        itemAspectRatio: 3.5,
        columns: (MediaQuery.sizeOf(context).width / 600).ceil(),
        itemBuilder: (final context, final data, final index) =>
            SearchGridListItem(
              space: space,
              data: data,
              selected: currentSearch.id == data.id,
              onTap: () => Navigator.pop(context, data),
            ),
      ),
    );
  }
}

class SearchGridListItem extends StatelessWidget {
  const SearchGridListItem({
    super.key,
    required this.space,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final String space;
  final ListSearch data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      hasImage: false,
      title: data.name,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (selected)
            Tooltip(
              message: context.localize().selectedLabel,
              child: CommonIcons.yes,
            ),
          if (data.internal)
            Tooltip(
              message: context.localize().predefinedLabel,
              child: CommonIcons.star,
            ),
          if (!data.internal)
            IconButton(
              icon: CommonIcons.edit,
              tooltip: context.localize().editLabel,
              onPressed: () async => showReturningDialog(
                context,
                builder: (final context) =>
                    SearchEditForm(space: space, name: data.name),
                onSuccess: (final context, _) =>
                    context.read<SearchListBloc>().add(const ListReloaded()),
              ),
            ),
        ],
      ),
    );
  }
}
