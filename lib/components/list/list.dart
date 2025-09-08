import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ListFinal,
        ListLoadBloc,
        ListLoadFailure,
        ListLoadInProgress,
        ListLoadSuccess,
        ListPageIncremented,
        ListPageReloaded,
        ListReloaded,
        ListSearchChanged,
        ListState;
import 'package:game_oclock/components/search/search_list.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;
import 'package:game_oclock/utils/localisation_extension.dart';

abstract class PaginatedListBuilder<T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const PaginatedListBuilder({
    super.key,
    required this.space,
    required this.itemBuilder,
  });

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String space;

  @override
  Widget build(final BuildContext context) {
    final ScrollController controller = ScrollController();
    controller.addListener(paginateListener(context, controller));

    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) {
        final listView = Scrollbar(
          controller: controller,
          child: list(context, state: state, controller: controller),
        );

        if (space.isEmpty) {
          return listView;
        }

        ListSearch? currentSearch;
        if (state is ListFinal<T>) {
          currentSearch = state.search;
        }

        return Column(
          children: [
            searchTile(context, search: currentSearch),
            Expanded(child: listView),
          ],
        );
      },
    );
  }

  ListTile searchTile(
    final BuildContext context, {
    required final ListSearch? search,
  }) {
    return ListTile(
      title: Text(search == null ? '-' : search.name),
      trailing: const Icon(CommonIcons.down),
      onTap: () async {
        final listBloc = context.read<LB>();
        showModalBottomSheet<ListSearch>(
          context: context,
          builder: (final context) => SearchListPage(space: space),
        ).then((final selectedSearch) {
          if (selectedSearch != null) {
            listBloc.add(ListSearchChanged(search: selectedSearch));
          }
        });
      },
    );
  }

  Widget list(
    final BuildContext context, {
    required final ListState<T> state,
    required final ScrollController controller,
  }) {
    List<T> items = [];
    Widget? trailing;
    if (state is ListFinal<T>) {
      if (state is ListLoadSuccess<T> && state.data.isEmpty) {
        return Center(child: Text(context.localize().emptyListLabel));
      }
      if (state is ListLoadFailure<T>) {
        if (state.data.isEmpty) {
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
        trailing = errorItemBuilder(
          context,
          () => context.read<LB>().add(const ListPageReloaded()),
        );
      }
      items = state.data;
    } else if (state is ListLoadInProgress<T>) {
      if (state.data == null || state.data!.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      items = state.data!;
      trailing = const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async => context.read<LB>().add(const ListReloaded()),
      child: listView(
        items: items,
        itemBuilder: itemBuilder,
        trailing: trailing,
        controller: controller,
      ),
    );
  }

  VoidCallback paginateListener(
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

  Widget listView({
    required final List<T> items,
    required final Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    final Widget? trailing,
    required final ScrollController controller,
  });

  Widget errorItemBuilder(final BuildContext context, final VoidCallback onTap);
}
