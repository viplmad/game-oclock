import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        Counter,
        CounterListBloc,
        ListFinal,
        ListLoadFailure,
        ListLoadInProgress,
        ListLoaded,
        ListPageIncremented,
        ListState;
import 'package:game_oclock/components/list_item.dart';
import 'package:game_oclock/models/models.dart' show SearchDTO;

class CounterList extends StatelessWidget {
  const CounterList({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (_) => CounterListBloc()..add(ListLoaded(search: SearchDTO())),
      child: GridList(
        itemBuilder:
            (final context, final counter) => ListItemGrid(
              title: '${counter.name} ${counter.data}',
              onTap: () => {},
            ),
      ),
    );
  }
}

class GridList extends StatelessWidget {
  const GridList({super.key, required this.itemBuilder});

  final Widget Function(BuildContext, Counter) itemBuilder;

  @override
  Widget build(final BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(paginateListener(context, scrollController));

    return BlocBuilder<CounterListBloc, ListState<Counter>>(
      builder: (final context, final state) {
        List<Counter> items = [];
        Widget? extraItem;
        if (state is ListFinal<Counter>) {
          if (state is ListLoadFailure<Counter>) {
            extraItem = ListItemGrid(
              title: 'Error - Tap to refresh',
              onTap:
                  () => {
                    context.read<CounterListBloc>().add(
                      ListLoaded(search: state.search),
                    ),
                  },
            );
          }
          items = state.data;
        } else if (state is ListLoadInProgress<Counter>) {
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
              final Counter item = items.elementAt(index);
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
        context.read<CounterListBloc>().add(const ListPageIncremented());
      }
    };
  }
}
