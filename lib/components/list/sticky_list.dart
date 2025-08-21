import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ListFinal,
        ListLoadBloc,
        ListLoadFailure,
        ListLoadInProgress,
        ListPageReloaded,
        ListState;

import 'list_item.dart';

class StickyListBuilder<T, LB extends ListLoadBloc<T>> extends StatelessWidget {
  const StickyListBuilder({
    super.key,
    required this.groupTransformer,
    required this.headerBuilder,
    required this.itemBuilder,
  });

  final Map<String, List<T>> Function(List<T> items) groupTransformer;
  final SliverPersistentHeaderDelegate Function(
    BuildContext contex,
    String title,
  )
  headerBuilder;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  @override
  Widget build(final BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) {
        return list(context, state: state, scrollController: scrollController);
      },
    );
  }

  Widget list(
    final BuildContext context, {
    required final ListState<T> state,
    required final ScrollController scrollController,
  }) {
    List<T> items = [];
    if (state is ListFinal<T>) {
      if (state is ListLoadFailure<T>) {
        return TileListItem(
          title: 'Error - Tap to refresh', // TODO
          onTap: () => context.read<LB>().add(const ListPageReloaded()),
        );
      }
      items = state.data;
    } else if (state is ListLoadInProgress<T>) {
      if (state.data == null || state.data!.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      items = state.data!;
      //trailing = const Center(child: CircularProgressIndicator());
    }

    return listView(
      items: items,
      itemBuilder: itemBuilder,
      controller: scrollController,
    );
  }

  Widget listView({
    required final List<T> items,
    required final Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    required final ScrollController controller,
  }) {
    return StickyList(
      items: groupTransformer(items),
      headerBuilder: headerBuilder,
      itemBuilder: itemBuilder,
      controller: controller,
    );
  }
}

class StickyList<T> extends StatelessWidget {
  const StickyList({
    super.key,
    required this.items,
    required this.headerBuilder,
    required this.itemBuilder,
    required this.controller,
  });

  final Map<String, List<T>> items;
  final SliverPersistentHeaderDelegate Function(
    BuildContext context,
    String title,
  )
  headerBuilder;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ScrollController controller;

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: controller,
      slivers: items.entries
          .map((final entry) {
            return SliverVerticalGroup<T>(
              items: entry.value,
              header: headerBuilder(context, entry.key),
              itemBuilder: itemBuilder,
            );
          })
          .toList(growable: false),
    );
  }
}

class SliverVerticalGroup<T> extends StatelessWidget {
  const SliverVerticalGroup({
    super.key,
    required this.items,
    required this.header,
    required this.itemBuilder,
  });

  final List<T> items;
  final SliverPersistentHeaderDelegate header;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  @override
  Widget build(final BuildContext context) {
    final count = items.length;
    return SliverMainAxisGroup(
      slivers: <Widget>[
        SliverPersistentHeader(pinned: true, delegate: header),
        SliverList.builder(
          itemCount: count,
          itemBuilder: (final BuildContext context, final int index) {
            final T item = items.elementAt(index);
            final Widget itemWidget = itemBuilder(context, item, index);

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: itemWidget,
            );
          },
        ),
      ],
    );
  }
}

class ListTileSliverHeader extends SliverPersistentHeaderDelegate {
  ListTileSliverHeader({required this.title, this.backgroundColor});

  final String title;
  final Color? backgroundColor;

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      child: ListTile(title: Text(title)),
    );
  }

  @override
  double get maxExtent => minExtent;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(
    covariant final SliverPersistentHeaderDelegate oldDelegate,
  ) => false;
}
