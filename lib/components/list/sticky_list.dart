import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart'
    show SliverStickyHeader;
import 'package:game_oclock/blocs/blocs.dart'
    show
        ListFinal,
        ListLoadBloc,
        ListLoadFailure,
        ListLoadInProgress,
        ListLoadSuccess,
        ListReloaded,
        ListState;
import 'package:game_oclock/components/skeletons/skeletons.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class StickyTopListBuilder<K, T, LB extends ListLoadBloc<T>>
    extends StickyListBuilder<K, T, LB> {
  const StickyTopListBuilder({
    super.key,
    required super.itemBuilder,
    this.borderRadius,
    super.controller,
    required super.groupTransformer,
    required super.headerBuilder,
  });

  final BorderRadiusGeometry? borderRadius;

  @override
  Widget listView({
    required final List<T> items,
    required final Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    required final ScrollController controller,
  }) {
    return StickyTopHeaderList(
      items: groupTransformer(items),
      headerBuilder: headerBuilder,
      itemBuilder: itemBuilder,
      borderRadius: borderRadius,
      controller: controller,
    );
  }

  @override
  Widget skeletonHeaderBuilder({final int order = 0}) {
    return TileListSkeletonItem(order: order);
  }

  @override
  Widget skeletonListView() {
    return StickyTopHeaderList(
      items: <int, List<int>>{
        0: List.filled(3, 0, growable: false),
        1: List.filled(3, 0, growable: false),
        2: List.filled(3, 0, growable: false),
      },
      headerBuilder: (_) => skeletonHeaderBuilder(),
      itemBuilder: (_, _, final index) => skeletonItemBuilder(order: index),
      borderRadius: borderRadius,
    );
  }
}

class StickySideListBuilder<K, T, LB extends ListLoadBloc<T>>
    extends StickyListBuilder<K, T, LB> {
  const StickySideListBuilder({
    super.key,
    required super.itemBuilder,
    this.borderRadius,
    super.controller,
    required super.groupTransformer,
    required super.headerBuilder,
  });

  final BorderRadiusGeometry? borderRadius;

  @override
  Widget listView({
    required final List<T> items,
    required final Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    required final ScrollController controller,
  }) {
    return StickySideHeaderList(
      items: groupTransformer(items),
      headerBuilder: headerBuilder,
      itemBuilder: itemBuilder,
      borderRadius: borderRadius,
      controller: controller,
    );
  }

  @override
  Widget skeletonHeaderBuilder({final int order = 0}) {
    return SideHeaderSkeletonItem(order: order);
  }

  @override
  Widget skeletonListView() {
    return StickySideHeaderList(
      items: <int, List<int>>{
        0: List.filled(3, 0, growable: false),
        1: List.filled(3, 0, growable: false),
        2: List.filled(3, 0, growable: false),
      },
      headerBuilder: (_) => skeletonHeaderBuilder(),
      itemBuilder: (_, _, final index) => skeletonItemBuilder(order: index),
      borderRadius: borderRadius,
    );
  }
}

abstract class StickyListBuilder<K, T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const StickyListBuilder({
    super.key,
    required this.itemBuilder,
    this.controller,
    required this.groupTransformer,
    required this.headerBuilder,
  });

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ScrollController? controller;
  final Widget Function(K key) headerBuilder;
  final Map<K, List<T>> Function(List<T> items) groupTransformer;

  @override
  Widget build(final BuildContext context) {
    final ScrollController controller = this.controller ?? ScrollController();

    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) {
        return Scrollbar(
          child: list(context, state: state, controller: controller),
        );
      },
    );
  }

  Widget list(
    final BuildContext context, {
    required final ListState<T> state,
    required final ScrollController controller,
  }) {
    List<T> items = [];
    if (state is ListLoadInProgress<T>) {
      if (state.data == null || state.data!.isEmpty) {
        return skeletonListView();
      }
      items = state.data!;
    } else if (state is ListFinal<T>) {
      if (state is ListLoadSuccess<T> && state.data.isEmpty) {
        return Center(child: Text(context.localize().emptyListLabel));
      }
      if (state is ListLoadFailure<T>) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.localize().errorPageLoadTitle),
              OutlinedButton.icon(
                icon: CommonIcons.reload,
                label: Text(context.localize().retryLabel),
                onPressed: () => context.read<LB>().add(const ListReloaded()),
              ),
            ],
          ),
        );
      }
      items = state.data;
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
  });

  Widget skeletonItemBuilder({final int order = 0}) {
    return TileListSkeletonItem(order: order);
  }

  Widget skeletonHeaderBuilder({final int order = 0});
  Widget skeletonListView();
}

class StickyTopHeaderList<K, T> extends StatelessWidget {
  const StickyTopHeaderList({
    super.key,
    required this.items,
    required this.headerBuilder,
    required this.itemBuilder,
    this.borderRadius,
    this.controller,
  });

  final Map<K, List<T>> items;
  final Widget Function(K key) headerBuilder;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final BorderRadiusGeometry? borderRadius;
  final ScrollController? controller;

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: controller,
      slivers: items.entries
          .map((final entry) {
            return SliverTopGroup<T>(
              items: entry.value,
              header: headerBuilder(entry.key),
              itemBuilder: itemBuilder,
              borderRadius: borderRadius,
            );
          })
          .toList(growable: false),
    );
  }
}

class StickySideHeaderList<K, T> extends StatelessWidget {
  const StickySideHeaderList({
    super.key,
    required this.items,
    required this.headerBuilder,
    required this.itemBuilder,
    this.borderRadius,
    this.controller,
  });

  final Map<K, List<T>> items;
  final Widget Function(K key) headerBuilder;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final BorderRadiusGeometry? borderRadius;
  final ScrollController? controller;

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: controller,
      slivers: items.entries
          .map((final entry) {
            return SliverSideGroup<T>(
              items: entry.value,
              header: headerBuilder(entry.key),
              itemBuilder: itemBuilder,
              borderRadius: borderRadius,
            );
          })
          .toList(growable: false),
    );
  }
}

class SliverTopGroup<T> extends StatelessWidget {
  const SliverTopGroup({
    super.key,
    required this.items,
    required this.header,
    required this.itemBuilder,
    this.borderRadius,
  });

  final List<T> items;
  final Widget header;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(final BuildContext context) {
    final count = items.length;

    return SliverMainAxisGroup(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeader(child: header),
        ),
        SliverList.builder(
          itemCount: count,
          itemBuilder: (final context, final index) {
            final T item = items.elementAt(index);
            final Widget itemWidget = itemBuilder(context, item, index);

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: borderRadius == null
                  ? itemWidget
                  : ClipRRect(borderRadius: borderRadius!, child: itemWidget),
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
    this.borderRadius,
  });

  final List<T> items;
  final Widget header;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(final BuildContext context) {
    final count = items.length;

    return SliverStickyHeader(
      overlapsContent: true,
      header: header,
      sliver: SliverPadding(
        padding: const EdgeInsets.only(left: 60),
        sliver: SliverList.builder(
          itemCount: count,
          itemBuilder: (final context, final index) {
            final T item = items.elementAt(index);
            final Widget itemWidget = itemBuilder(context, item, index);

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: borderRadius == null
                  ? itemWidget
                  : ClipRRect(borderRadius: borderRadius!, child: itemWidget),
            );
          },
        ),
      ),
    );
  }
}

class SliverHeader extends SliverPersistentHeaderDelegate {
  SliverHeader({required this.child});

  final Widget child;

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    return child;
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
