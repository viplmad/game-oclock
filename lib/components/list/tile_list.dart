import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show ListLoadBloc;
import 'package:game_oclock/components/skeletons/skeletons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'list.dart';
import 'list_item.dart';

class TileListBuilder<T, LB extends ListLoadBloc<T>>
    extends PaginatedListBuilder<T, LB> {
  const TileListBuilder({
    super.key,
    required super.itemBuilder,
    this.borderRadius,
  });

  final BorderRadiusGeometry? borderRadius;

  @override
  Widget listView({
    required final List<T> items,
    required final Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    final Widget? trailing,
    required final ScrollController controller,
  }) {
    return TileList(
      items: items,
      itemBuilder: itemBuilder,
      trailing: trailing,
      borderRadius: borderRadius,
      controller: controller,
    );
  }

  @override
  Widget errorItemBuilder(
    final BuildContext context,
    final VoidCallback onTap,
  ) {
    return TileListErrorItem(
      title: context.localize().errorListPageLoadTitle,
      onRetryTap: onTap,
    );
  }

  @override
  Widget skeletonItemBuilder({final int order = 0}) {
    return TileListSkeletonItem(order: order, hasImage: true);
  }

  @override
  Widget skeletonListView() {
    return TileListSkeleton(
      itemBuilder: (final index) => skeletonItemBuilder(order: index),
      borderRadius: borderRadius,
    );
  }
}

class ReorderableListBuilder<T, LB extends ListLoadBloc<T>>
    extends TileListBuilder<T, LB> {
  const ReorderableListBuilder({
    super.key,
    required super.itemBuilder,
    super.borderRadius,
    required this.onReorder,
    this.readOnly = false,
  });

  final ReorderCallback onReorder;
  final bool readOnly;

  @override
  Widget listView({
    required final List<T> items,
    required final Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    final Widget? trailing,
    required final ScrollController controller,
  }) {
    return ReorderableTileList<T>(
      items: items,
      itemBuilder: itemBuilder,
      onReorder: onReorder,
      trailing: trailing,
      borderRadius: borderRadius,
      controller: controller,
      readOnly: readOnly,
    );
  }
}

class TileList<T> extends StatelessWidget {
  const TileList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.trailing,
    this.borderRadius,
    this.controller,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? trailing;
  final BorderRadiusGeometry? borderRadius;
  final ScrollController? controller;

  @override
  Widget build(final BuildContext context) {
    final count = countWithTrailing(items, trailing);

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: count,
      controller: controller,
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

class ReorderableTileList<T> extends StatelessWidget {
  const ReorderableTileList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
    this.trailing,
    this.borderRadius,
    this.controller,
    this.readOnly = false,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ReorderCallback onReorder;
  final Widget? trailing;
  final BorderRadiusGeometry? borderRadius;
  final ScrollController? controller;
  final bool readOnly;

  @override
  Widget build(final BuildContext context) {
    final count = countWithTrailing(items, trailing);

    return ReorderableListView.builder(
      buildDefaultDragHandles: !readOnly,
      shrinkWrap: true,
      onReorder: onReorder,
      itemCount: count,
      scrollController: controller,
      itemBuilder: (final context, final index) {
        Widget itemWidget;
        if (index == count - 1 && trailing != null) {
          itemWidget = trailing!;
        } else {
          final T item = items.elementAt(index);
          itemWidget = itemBuilder(context, item, index);
        }

        return Padding(
          key: Key('${itemWidget.hashCode}'), // TODO
          padding: const EdgeInsets.all(4.0),
          child: borderRadius == null
              ? itemWidget
              : ClipRRect(borderRadius: borderRadius!, child: itemWidget),
        );
      },
    );
  }
}
