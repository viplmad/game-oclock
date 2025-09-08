import 'package:flutter/material.dart';
import 'package:game_oclock/blocs/blocs.dart' show ListLoadBloc;
import 'package:game_oclock/utils/localisation_extension.dart';

import 'list.dart';
import 'list_item.dart';

class GridListBuilder<T, LB extends ListLoadBloc<T>>
    extends PaginatedListBuilder<T, LB> {
  const GridListBuilder({
    super.key,
    required super.space,
    required super.itemBuilder,
  });

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
      controller: controller,
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
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? trailing;
  final ScrollController controller;

  @override
  Widget build(final BuildContext context) {
    final count = items.length + (trailing == null ? 0 : 1);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: count,
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.85, // Steam header aspect ratio // TODO variable
        crossAxisCount: (MediaQuery.sizeOf(context).width / 400).ceil(),
      ),
      itemBuilder: (final BuildContext context, final int index) {
        Widget itemWidget;
        if (index == count - 1 && trailing != null) {
          itemWidget = trailing!;
        } else {
          final T item = items.elementAt(index);
          itemWidget = itemBuilder(context, item, index);
        }

        return Padding(padding: const EdgeInsets.all(4.0), child: itemWidget);
      },
    );
  }
}
