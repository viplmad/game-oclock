import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show ListLoadBloc;

import 'grid_list.dart';

class ReorderableListBuilder<T, LB extends ListLoadBloc<T>>
    extends ListBuilder<T, LB> {
  const ReorderableListBuilder({
    super.key,
    required super.space,
    required super.itemBuilder,
    required this.onReorder,
  });

  final ReorderCallback onReorder;

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
      controller: controller,
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
    required this.controller,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ReorderCallback onReorder;
  final Widget? trailing;
  final ScrollController controller;

  @override
  Widget build(final BuildContext context) {
    final count = items.length + (trailing == null ? 0 : 1);
    return ReorderableListView.builder(
      shrinkWrap: true,
      onReorder: onReorder,
      itemCount: count,
      scrollController: controller,
      itemBuilder: (final BuildContext context, final int index) {
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
          child: itemWidget,
        );
      },
    );
  }
}
