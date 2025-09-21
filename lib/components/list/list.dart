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
  const PaginatedListBuilder({super.key, required this.itemBuilder});

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  @override
  Widget build(final BuildContext context) {
    final ScrollController controller = ScrollController();
    controller.addListener(paginateListener(context, controller));

    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) => Scrollbar(
        controller: controller,
        child: list(context, state: state, controller: controller),
      ),
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

class ListToolbar extends StatelessWidget {
  const ListToolbar({super.key, required this.toolbars, required this.child});

  final List<Widget> toolbars;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    if (toolbars.isEmpty) {
      return child;
    }

    return Column(
      children: [
        ...toolbars,
        Expanded(child: child),
      ],
    );
  }
}

class ListFilterToolbarBuilder<T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const ListFilterToolbarBuilder({super.key, required this.space})
    : assert(space.length > 0);

  final String space;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) {
        ListSearch? currentSearch;
        if (state is ListFinal<T>) {
          currentSearch = state.search;
        }

        return ListFilterToolbar(
          space: space,
          search: currentSearch,
          onSearchChanged: (final context, final selectedSearch) {
            context.read<LB>().add(ListSearchChanged(search: selectedSearch));
          },
        );
      },
    );
  }
}

class ListFilterToolbar extends StatelessWidget {
  const ListFilterToolbar({
    super.key,
    required this.space,
    required this.search,
    required this.onSearchChanged,
  }) : assert(space.length > 0);

  final String space;
  final ListSearch? search;
  final void Function(BuildContext context, ListSearch selectedSearch)
  onSearchChanged;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      // TODO filter chips
      title: Text(search == null ? '-' : search!.name), // TODO empty search
      trailing: const Icon(CommonIcons.down),
      onTap: () async {
        showModalBottomSheet<ListSearch>(
          context: context,
          builder: (final context) => SearchListPage(space: space),
        ).then((final selectedSearch) {
          if (selectedSearch != null && context.mounted) {
            onSearchChanged(context, selectedSearch);
          }
        });
      },
    );
  }
}

class ListButtonToolbar extends StatelessWidget {
  const ListButtonToolbar({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton.icon(
        label: Text(label),
        icon: icon,
        onPressed: onTap,
      ),
    );
  }
}
