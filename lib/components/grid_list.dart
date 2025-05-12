import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ListFinal,
        ListLoadBloc,
        ListLoadFailure,
        ListLoadInProgress,
        ListLoaded,
        ListPageIncremented,
        ListSearchChanged,
        ListState;
import 'package:game_oclock/models/models.dart' show ListSearch, SearchDTO;
import 'package:game_oclock/pages/filters_list.dart';

import 'list_item.dart';

class GridListBuilder<T, LB extends ListLoadBloc<T>> extends StatelessWidget {
  const GridListBuilder({
    super.key,
    required this.space,
    required this.itemBuilder,
  });

  final Widget Function(BuildContext, T) itemBuilder;
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

        ListSearch? currentFilter;
        if (state is ListFinal<T>) {
          currentFilter = state.search;
        }

        return Column(
          children: [
            filterTile(context, filter: currentFilter),
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

  ListTile filterTile(
    final BuildContext context, {
    required final ListSearch? filter,
  }) {
    return ListTile(
      title: Text(filter == null ? '-' : filter.name),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () async {
        final listBloc = context.read<LB>();
        showModalBottomSheet<ListSearch>(
          context: context,
          builder: (final context) => FilterListPage(space: space),
        ).then((final selectedFilter) {
          if (selectedFilter != null) {
            listBloc.add(ListSearchChanged(search: selectedFilter));
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
          title: 'Error - Tap to refresh',
          onTap:
              () => {context.read<LB>().add(ListLoaded(search: state.search))},
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

    return GridList(
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
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget? trailing;
  final ScrollController controller;

  @override
  Widget build(final BuildContext context) {
    final count = items.length + (trailing == null ? 0 : 1);
    return GridView.builder(
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
          itemWidget = itemBuilder(context, item);
        }

        return Padding(padding: const EdgeInsets.all(4.0), child: itemWidget);
      },
    );
  }
}
