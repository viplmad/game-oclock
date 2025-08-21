import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/action/action_state.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ActionState,
        FunctionActionBloc,
        LayoutTierBloc,
        LayoutTierState,
        ListLoadBloc,
        ListQuicksearchChanged,
        MinimizedLayoutBloc;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier;

import 'list/grid_list.dart';

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
  });

  final String title;
  final String searchSpace;

  final Widget Function(BuildContext context, T data, VoidCallback onClosed)
  detailBuilder;
  final Widget Function(BuildContext context, T data, VoidCallback onPressed)
  listItemBuilder;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LayoutTierBloc, LayoutTierState>(
      builder: (final context, final layoutState) {
        final layoutTier = layoutState.tier;

        return BlocListener<SB, ActionState<T?>>(
          listener: (final context, final selectState) {
            final selectedData =
                (selectState is ActionFinal)
                    ? (selectState as ActionFinal<T?, T?>).data
                    : null;

            // Allow minimized if selected
            context.read<MinimizedLayoutBloc>().add(
              ActionStarted(data: selectedData != null),
            );
          },
          child: BlocBuilder<SB, ActionState<T?>>(
            builder: (final context, final selectState) {
              final selectedData =
                  (selectState is ActionFinal)
                      ? (selectState as ActionFinal<T?, T?>).data
                      : null;
              if (layoutTier == LayoutTier.compact) {
                if (selectedData == null) {
                  return _list(context, selectedData: selectedData);
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
                      child: _list(context, selectedData: selectedData),
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
          ),
        );
      },
    );
  }

  Widget _detail(
    final BuildContext context, {
    required final T? selectedData,
    required final SB selectBloc,
  }) {
    return selectedData == null
        ? _emptyDetail()
        : detailBuilder(
          context,
          selectedData,
          () => _select(context, selectBloc: selectBloc, data: null),
        );
  }

  Widget _emptyDetail() {
    return const Center(
      child: Text('Select something first'), // TODO i18n
    );
  }

  Widget _list(final BuildContext context, {required final T? selectedData}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          SearchAnchor(
            builder: (final context, final controller) {
              return IconButton(
                icon: const Icon(CommonIcons.search),
                onPressed: () {
                  controller.openView();
                },
              );
            },
            suggestionsBuilder:
                (final context, final controller) => List.empty(),
            viewOnChanged: // TODO not called when clear
                (final value) => context.read<LB>().add(
                  ListQuicksearchChanged(quicksearch: value),
                ),
            isFullScreen: false,
          ),
        ],
      ),
      body: GridListBuilder<T, LB>(
        space: searchSpace,
        itemBuilder:
            (final context, final data, final index) => listItemBuilder(
              context,
              data,
              () => _select(
                context,
                selectBloc: context.read<SB>(),
                data:
                    data == selectedData
                        ? null // Remove selection if pressed on the same one
                        : data,
              ),
            ),
      ),
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
