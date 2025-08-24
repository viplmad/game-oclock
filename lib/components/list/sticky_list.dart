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

class StickyListBuilder<K, T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const StickyListBuilder({
    super.key,
    required this.titleTransformer,
    required this.groupTransformer,
    required this.itemBuilder,
    this.controller,
  });

  final String Function(K key) titleTransformer;
  final Map<K, List<T>> Function(List<T> items) groupTransformer;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ScrollController? controller;

  @override
  Widget build(final BuildContext context) {
    final ScrollController controller = this.controller ?? ScrollController();

    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) {
        return list(context, state: state, controller: controller);
      },
    );
  }

  Widget list(
    final BuildContext context, {
    required final ListState<T> state,
    required final ScrollController controller,
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
      controller: controller,
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
      titleTransformer: titleTransformer,
      itemBuilder: itemBuilder,
      controller: controller,
    );
  }
}

class StickyList<K, T> extends StatelessWidget {
  const StickyList({
    super.key,
    required this.items,
    required this.titleTransformer,
    required this.itemBuilder,
    required this.controller,
  });

  final Map<K, List<T>> items;
  final String Function(K key) titleTransformer;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ScrollController controller;

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: controller,
      slivers: items.entries
          .map((final entry) {
            return SliverSideGroup<T>(
              items: entry.value,
              header: SliverSideHeader(
                title: titleTransformer(entry.key),
                backgroundColor: Colors.grey[800],
              ),
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

class SliverSideGroup<T> extends StatelessWidget {
  const SliverSideGroup({
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
        SliverPersistentHeader(pinned: true, delegate: header, floating: true),
        SliverList.builder(
          itemCount: count,
          itemBuilder: (final BuildContext context, final int index) {
            final T item = items.elementAt(index);
            final Widget itemWidget = itemBuilder(context, item, index);

            return Padding(
              padding: const EdgeInsets.only(
                left: 48.0,
                top: 4.0,
                right: 4.0,
                bottom: 4.0,
              ),
              child: itemWidget,
            );
          },
        ),
      ],
    );
  }
}

class SliverVerticalHeader extends SliverPersistentHeaderDelegate {
  SliverVerticalHeader({required this.title, this.backgroundColor});

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
      child: ListTile(
        title: Text(
          title,
          style: DefaultTextStyle.of(
            context,
          ).style.copyWith(color: Colors.white),
        ),
      ),
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

class SliverSideHeader extends SliverPersistentHeaderDelegate {
  SliverSideHeader({required this.title, this.backgroundColor});

  final String title;
  final Color? backgroundColor;

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 44.0,
        width: 44.0,
        child: CircleAvatar(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          child: Text(
            title,
            style: DefaultTextStyle.of(
              context,
            ).style.copyWith(color: Colors.white),
          ),
        ),
      ),
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
