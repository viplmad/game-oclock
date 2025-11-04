import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show ListLoadBloc;
import 'package:game_oclock/components/list/centered_list.dart';
import 'package:game_oclock/components/skeletons/skeletons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'list.dart';
import 'list_item.dart';

class GridListBuilder<T, LB extends ListLoadBloc<T>>
    extends PaginatedListBuilder<T, LB> {
  const GridListBuilder({
    super.key,
    required super.itemBuilder,
    this.borderRadius,
    required this.itemAspectRatio,
    required this.columns,
  });

  final BorderRadiusGeometry? borderRadius;
  final double itemAspectRatio;
  final int columns;

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
      borderRadius: borderRadius,
      controller: controller,
      itemAspectRatio: itemAspectRatio,
      columns: columns,
    );
  }

  @override
  Widget errorItemBuilder(
    final BuildContext context,
    final VoidCallback onTap,
  ) {
    return GridListErrorItem(
      title: context.localize().errorListPageLoadTitle,
      onRetryTap: onTap,
    );
  }

  @override
  Widget skeletonItemBuilder({final int order = 0}) {
    return GridListSkeletonItem(order: order);
  }

  @override
  Widget skeletonListView() {
    return GridListSkeleton(
      itemBuilder: (final index) => skeletonItemBuilder(order: index),
      borderRadius: borderRadius,
      itemAspectRatio: itemAspectRatio,
      columns: columns,
    );
  }
}

class GridList<T> extends StatelessWidget {
  const GridList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.trailing,
    this.borderRadius,
    this.controller,
    required this.itemAspectRatio,
    required this.columns,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? trailing;
  final BorderRadiusGeometry? borderRadius;
  final ScrollController? controller;
  final double itemAspectRatio;
  final int columns;

  @override
  Widget build(final BuildContext context) {
    return _GridList(
      items: items,
      itemBuilder: itemBuilder,
      trailing: trailing,
      borderRadius: borderRadius,
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: itemAspectRatio,
        crossAxisCount: columns,
      ),
    );
  }
}

class CenteredGridList<T> extends StatelessWidget {
  const CenteredGridList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.trailing,
    this.borderRadius,
    this.controller,
    required this.itemAspectRatio,
    required this.columns,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? trailing;
  final BorderRadiusGeometry? borderRadius;
  final ScrollController? controller;
  final double itemAspectRatio;
  final int columns;

  @override
  Widget build(final BuildContext context) {
    final count = countWithTrailing(items, trailing);

    return _GridList(
      items: items,
      itemBuilder: itemBuilder,
      trailing: trailing,
      borderRadius: borderRadius,
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndCenteredLast(
        itemCount: count,
        childAspectRatio: itemAspectRatio,
        crossAxisCount: columns,
      ),
    );
  }
}

class _GridList<T> extends StatelessWidget {
  const _GridList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.trailing,
    this.borderRadius,
    this.controller,
    required this.gridDelegate,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? trailing;
  final BorderRadiusGeometry? borderRadius;
  final ScrollController? controller;
  final SliverGridDelegate gridDelegate;

  @override
  Widget build(final BuildContext context) {
    final count = countWithTrailing(items, trailing);

    return GridView.builder(
      shrinkWrap: true,
      itemCount: count,
      controller: controller,
      gridDelegate: gridDelegate,
      itemBuilder: (final context, final index) {
        Widget itemWidget;
        if (index == count - 1 && trailing != null) {
          itemWidget = trailing!;
        } else {
          final T item = items.elementAt(index);
          itemWidget = itemBuilder(context, item, index);
        }

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: borderRadius == null
              ? itemWidget
              : ClipRRect(borderRadius: borderRadius!, child: itemWidget),
        );
      },
    );
  }
}
