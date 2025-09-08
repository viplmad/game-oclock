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
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class StickyTopListBuilder<K, T, LB extends ListLoadBloc<T>>
    extends StickyListBuilder<K, T, LB> {
  const StickyTopListBuilder({
    super.key,
    required super.groupTransformer,
    required super.headerBuilder,
    required super.itemBuilder,
    super.controller,
  });

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
      controller: controller,
    );
  }
}

class StickySideListBuilder<K, T, LB extends ListLoadBloc<T>>
    extends StickyListBuilder<K, T, LB> {
  const StickySideListBuilder({
    super.key,
    required super.groupTransformer,
    required super.headerBuilder,
    required super.itemBuilder,
    super.controller,
  });

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
      controller: controller,
    );
  }
}

abstract class StickyListBuilder<K, T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const StickyListBuilder({
    super.key,
    required this.groupTransformer,
    required this.headerBuilder,
    required this.itemBuilder,
    this.controller,
  });

  final Widget Function(K key) headerBuilder;
  final Map<K, List<T>> Function(List<T> items) groupTransformer;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ScrollController? controller;

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
    if (state is ListFinal<T>) {
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
                icon: const Icon(CommonIcons.reload),
                label: Text(context.localize().retryLabel),
                onPressed: () => context.read<LB>().add(const ListReloaded()),
              ),
            ],
          ),
        );
      }
      items = state.data;
    } else if (state is ListLoadInProgress<T>) {
      if (state.data == null || state.data!.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      items = state.data!;
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
}

class StickyTopHeaderList<K, T> extends StatelessWidget {
  const StickyTopHeaderList({
    super.key,
    required this.items,
    required this.headerBuilder,
    required this.itemBuilder,
    required this.controller,
  });

  final Map<K, List<T>> items;
  final Widget Function(K key) headerBuilder;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ScrollController controller;

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
    required this.controller,
  });

  final Map<K, List<T>> items;
  final Widget Function(K key) headerBuilder;
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
              header: headerBuilder(entry.key),
              itemBuilder: itemBuilder,
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
  });

  final List<T> items;
  final Widget header;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

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
  final Widget header;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

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
          itemBuilder: (final BuildContext context, final int index) {
            final T item = items.elementAt(index);
            final Widget itemWidget = itemBuilder(context, item, index);

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: itemWidget,
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
