import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ListFinal,
        ListLoadBloc,
        ListLoadFailure,
        ListLoadInProgress,
        ListPageIncremented,
        ListReloaded,
        ListSearchChanged,
        ListState;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;

import 'list_item.dart';
import 'search_list.dart';

class GridListBuilder<T, LB extends ListLoadBloc<T>>
    extends ListBuilder<T, LB> {
  const GridListBuilder({
    super.key,
    required super.space,
    required super.itemBuilder,
  });

  @override
  Widget listView({
    required final List<T> items,
    required final Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    final Widget? trailing,
    required final ScrollController controller,
  }) {
    return GridList(
      items: items,
      itemBuilder: itemBuilder,
      trailing: trailing,
      controller: controller,
    );
  }
}

// TODO Move
abstract class ListBuilder<T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const ListBuilder({
    super.key,
    required this.space,
    required this.itemBuilder,
  });

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String space;

  @override
  Widget build(final BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(paginateListener(context, scrollController));

    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) {
        if (space.isEmpty) {
          return list(
            context,
            state: state,
            scrollController: scrollController,
          );
        }

        ListSearch? currentSearch;
        if (state is ListFinal<T>) {
          currentSearch = state.search;
        }

        return Column(
          children: [
            searchTile(context, search: currentSearch),
            Expanded(
              child: list(
                context,
                state: state,
                scrollController: scrollController,
              ),
            ),
          ],
        );
      },
    );
  }

  ListTile searchTile(
    final BuildContext context, {
    required final ListSearch? search,
  }) {
    return ListTile(
      title: Text(search == null ? '-' : search.name),
      trailing: const Icon(CommonIcons.down),
      onTap: () async {
        final listBloc = context.read<LB>();
        showModalBottomSheet<ListSearch>(
          context: context,
          builder: (final context) => SearchListPage(space: space),
        ).then((final selectedSearch) {
          if (selectedSearch != null) {
            listBloc.add(ListSearchChanged(search: selectedSearch));
          }
        });
      },
    );
  }

  Widget list(
    final BuildContext context, {
    required final ListState<T> state,
    required final ScrollController scrollController,
  }) {
    List<T> items = [];
    Widget? trailing;
    if (state is ListFinal<T>) {
      if (state is ListLoadFailure<T>) {
        trailing = ListItemGrid(
          title: 'Error - Tap to refresh', // TODO
          onTap: () => context.read<LB>().add(const ListReloaded()),
        );
      }
      items = state.data;
    } else if (state is ListLoadInProgress<T>) {
      if (state.data == null || state.data!.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      items = state.data!;
      trailing = const Center(child: CircularProgressIndicator());
    }

    return listView(
      items: items,
      itemBuilder: itemBuilder,
      trailing: trailing,
      controller: scrollController,
    );
  }

  VoidCallback paginateListener(
    final BuildContext context,
    final ScrollController scrollController,
  ) {
    return () {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<LB>().add(const ListPageIncremented());
      }
    };
  }

  Widget listView({
    required final List<T> items,
    required final Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    final Widget? trailing,
    required final ScrollController controller,
  });
}

class GridList<T> extends StatelessWidget {
  const GridList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.trailing,
    required this.controller,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? trailing;
  final ScrollController controller;

  @override
  Widget build(final BuildContext context) {
    final count = items.length + (trailing == null ? 0 : 1);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: count,
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.85, // Steam header aspect ratio
        crossAxisCount: (MediaQuery.sizeOf(context).width / 400).ceil(),
      ),
      itemBuilder: (final BuildContext context, final int index) {
        Widget itemWidget;
        if (index == count - 1 && trailing != null) {
          itemWidget = trailing!;
        } else {
          final T item = items.elementAt(index);
          itemWidget = itemBuilder(context, item, index);
        }

        return Padding(padding: const EdgeInsets.all(4.0), child: itemWidget);
      },
    );
  }
}
