import 'package:flutter/material.dart';

class ReorderableTileList<T> extends StatelessWidget {
  const ReorderableTileList({
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
    return ReorderableListView.builder(
      shrinkWrap: true,
      onReorder: (final oldIndex, final newIndex) {
        print('$oldIndex -> $newIndex'); // TODO
      },
      itemCount: count,
      scrollController: controller,
      itemBuilder: (final BuildContext context, final int index) {
        Widget itemWidget;
        if (index == count - 1 && trailing != null) {
          itemWidget = trailing!;
        } else {
          final T item = items.elementAt(index);
          itemWidget = itemBuilder(context, item);
        }

        return Padding(
          key: Key('$index'),
          padding: const EdgeInsets.all(4.0),
          child: itemWidget,
        );
      },
    );
  }
}
