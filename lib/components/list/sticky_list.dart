import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:game_oclock/utils/show_snackbar.dart';

class StickyTopListBuilder<K, T extends Object, LB extends ListLoadBloc<T>>
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
    return StickyTopHeaderListSkeleton(
      headerBuilder: () => skeletonHeaderBuilder(),
      itemBuilder: (final index) => skeletonItemBuilder(order: index),
      borderRadius: borderRadius,
    );
  }
}

abstract class StickyListBuilder<
  K,
  T extends Object,
  LB extends ListLoadBloc<T>
>
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

    return BlocConsumer<LB, ListState<T>>(
      listener: (final context, final state) {
        if (state is ListLoadFailure<T>) {
          showErrorSnackBar(
            context,
            name: context.localize().unableToLoadListLabel,
            error: state.error,
          );
        }
      },
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
