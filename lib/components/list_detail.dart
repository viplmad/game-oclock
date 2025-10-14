import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/action/action_state.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ActionState,
        FunctionActionBloc,
        ListLoadBloc,
        ListQuicksearchChanged,
        ListReloaded,
        ListStyleBloc,
        MinimizedLayoutBloc;
import 'package:game_oclock/components/list/list.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier, ListStyle;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'full_search_appp_bar.dart';
import 'list/grid_list.dart';
import 'list/tile_list.dart';

class ListDetailBuilder<
  T,
  SB extends FunctionActionBloc<T?, T?>,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  const ListDetailBuilder({
    super.key,
    required this.title,
    required this.searchSpace,
    required this.detailBuilder,
    required this.listItemBuilder,
    this.floatingActionButton,
  });

  final String title;
  final String searchSpace;
  final FloatingActionButton? floatingActionButton;

  final Widget Function(BuildContext context, T data, VoidCallback onClosed)
  detailBuilder;
  final Widget Function(
    BuildContext context,
    ListStyle style,
    T data,
    VoidCallback onTap,
  )
  listItemBuilder;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return BlocListener<SB, ActionState<T?>>(
      listener: (final context, final selectState) {
        final selectedData = (selectState is ActionFinal<T?, T?>)
            ? selectState.data
            : null;

        // Allow minimized if selected
        context.read<MinimizedLayoutBloc>().add(
          ActionStarted(data: selectedData != null),
        );
      },
      child: BlocBuilder<ListStyleBloc, ActionState<ListStyle>>(
        builder: (final context, final listStyleState) {
          final selectedStyle =
              (listStyleState is ActionFinal<ListStyle, ListStyle>)
              ? listStyleState.data
              : ListStyle.tile;

          return BlocBuilder<SB, ActionState<T?>>(
            builder: (final context, final selectState) {
              final selectedData = (selectState is ActionFinal<T?, T?>)
                  ? selectState.data
                  : null;

              if (layoutTier == LayoutTier.compact) {
                if (selectedData == null) {
                  return _list(
                    context,
                    selectedData: selectedData,
                    selectedStyle: selectedStyle,
                  );
                } else {
                  return _detail(
                    context,
                    selectedData: selectedData,
                    selectBloc: context.read<SB>(),
                  );
                }
              } else {
                return Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: _list(
                        context,
                        selectedData: selectedData,
                        selectedStyle: selectedStyle,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _detail(
                        context,
                        selectedData: selectedData,
                        selectBloc: context.read<SB>(),
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _detail(
    final BuildContext context, {
    required final T? selectedData,
    required final SB selectBloc,
  }) {
    return selectedData == null
        ? _emptyDetail(context)
        : detailBuilder(
            context,
            selectedData,
            () => _select(context, selectBloc: selectBloc, data: null),
          );
  }

  Widget _emptyDetail(final BuildContext context) {
    return Center(child: Text(context.localize().emptyListDetailLabel));
  }

  Widget _list(
    final BuildContext context, {
    required final T? selectedData,
    required final ListStyle selectedStyle,
  }) {
    return Scaffold(
      appBar: FullSearchAppBar(
        title: title,
        onSearchChanged: (final value) =>
            context.read<LB>().add(ListQuicksearchChanged(quicksearch: value)),
        actions: [
          SegmentedButton<ListStyle>(
            segments: <ButtonSegment<ListStyle>>[
              ButtonSegment<ListStyle>(
                value: ListStyle.tile,
                label: Text(context.localize().listStyleTileLabel),
                icon: CommonIcons.listStyleTile,
              ),
              ButtonSegment<ListStyle>(
                value: ListStyle.grid,
                label: Text(context.localize().listStyleGridLabel),
                icon: CommonIcons.listStyleGrid,
              ),
            ],
            selected: {selectedStyle},
            onSelectionChanged: (final newSelection) {
              context.read<ListStyleBloc>().add(
                ActionStarted(data: newSelection.first),
              );
            },
          ),
          IconButton(
            icon: CommonIcons.reload,
            tooltip: context.localize().reloadLabel,
            onPressed: () => context.read<LB>().add(const ListReloaded()),
          ),
        ],
      ),
      body: ListToolbar(
        toolbars: [ListFilterToolbarBuilder<T, LB>(space: searchSpace)],
        child: selectedStyle == ListStyle.grid
            ? GridListBuilder<T, LB>(
                itemAspectRatio: 1.85, // Steam header aspect ratio
                columns: (MediaQuery.sizeOf(context).width / 400).ceil(),
                itemBuilder: (final context, final data, final index) =>
                    listItemBuilder(
                      context,
                      ListStyle.grid,
                      data,
                      () => _selectRemoveIfSame(
                        context,
                        selectBloc: context.read<SB>(),
                        data: data,
                        selectedData: selectedData,
                      ),
                    ),
              )
            : TileListBuilder<T, LB>(
                itemBuilder: (final context, final data, final index) =>
                    listItemBuilder(
                      context,
                      ListStyle.tile,
                      data,
                      () => _selectRemoveIfSame(
                        context,
                        selectBloc: context.read<SB>(),
                        data: data,
                        selectedData: selectedData,
                      ),
                    ),
              ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  void _selectRemoveIfSame(
    final BuildContext context, {
    required final SB selectBloc,
    required final T? data,
    required final T? selectedData,
  }) {
    _select(
      context,
      selectBloc: context.read<SB>(),
      data: data == selectedData
          ? null // Remove selection if pressed on the same one
          : data,
    );
  }

  void _select(
    final BuildContext context, {
    required final SB selectBloc,
    required final T? data,
  }) {
    selectBloc.add(ActionStarted(data: data));
  }
}
