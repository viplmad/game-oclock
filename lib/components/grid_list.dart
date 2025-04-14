import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ListFinal,
        ListLoadBloc,
        ListLoadFailure,
        ListLoadInProgress,
        ListLoaded,
        ListPageIncremented,
        ListState;

import 'list_item.dart';

class GridList<T, LB extends ListLoadBloc<T>> extends StatelessWidget {
  const GridList({super.key, required this.itemBuilder});

  final Widget Function(BuildContext, T) itemBuilder;

  @override
  Widget build(final BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(paginateListener(context, scrollController));

    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) {
        List<T> items = [];
        Widget? extraItem;
        if (state is ListFinal<T>) {
          if (state is ListLoadFailure<T>) {
            extraItem = ListItemGrid(
              title: 'Error - Tap to refresh',
              onTap:
                  () => {
                    context.read<LB>().add(ListLoaded(search: state.search)),
                  },
            );
          }
          items = state.data;
        } else if (state is ListLoadInProgress<T>) {
          if (state.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // TODO does not show if first was error
          }
          items = state.data!;
          extraItem = const Center(child: CircularProgressIndicator());
        }

        final count = items.length + (extraItem == null ? 0 : 1);
        return GridView.builder(
          itemCount: count,
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.85, // Steam header aspect ratio
            crossAxisCount: (MediaQuery.sizeOf(context).width / 400).ceil(),
          ),
          itemBuilder: (final BuildContext context, final int index) {
            Widget itemWidget;
            if (index == count - 1 && extraItem != null) {
              itemWidget = extraItem;
            } else {
              final T item = items.elementAt(index);
              itemWidget = itemBuilder(context, item);
            }

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: itemWidget,
            );
          },
        );
      },
    );
  }

  void Function() paginateListener(
    final BuildContext context,
    final ScrollController scrollController,
  ) {
    return () {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<LB>().add(const ListPageIncremented());
      }
    };
  }
}
