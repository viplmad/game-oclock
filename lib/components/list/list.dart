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
        ListState;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

int countWithTrailing(final List items, final Widget? trailing) =>
    items.length + (trailing == null ? 0 : 1);

abstract class PaginatedListBuilder<T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const PaginatedListBuilder({
    super.key,
    required this.itemBuilder,
    this.controller,
  });

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ScrollController? controller;

  @override
  Widget build(final BuildContext context) {
    final ScrollController controller = this.controller ?? ScrollController();
    controller.addListener(_paginateListener(context, controller));

    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) => Scrollbar(
        controller: controller,
        child: _list(context, state: state, controller: controller),
      ),
    );
  }

  Widget _list(
    final BuildContext context, {
    required final ListState<T> state,
    required final ScrollController controller,
  }) {
    List<T> items = [];
    Widget? trailing;
    if (state is ListLoadInProgress<T>) {
      if (state.data == null || state.data!.isEmpty) {
        return skeletonListView();
      }
      items = state.data!;
      trailing = skeletonItemBuilder();
    } else if (state is ListFinal<T>) {
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
                  icon: CommonIcons.reload,
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

  VoidCallback _paginateListener(
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
  Widget skeletonItemBuilder({final int order = 0});
  Widget skeletonListView();
}
