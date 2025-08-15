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

import 'grid_list.dart';

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

        return BlocBuilder<SB, ActionState<T?>>(
          builder: (final context, final selectState) {
            final selectedData =
                (selectState is ActionFinal)
                    ? (selectState as ActionFinal<T?, T?>).data
                    : null;
            if (layoutTier == LayoutTier.compact) {
              if (selectedData != null) {
                return detail(
                  context,
                  selectedData: selectedData,
                  selectBloc: context.read<SB>(),
                );
              } else {
                return list(context, selectedData: selectedData);
              }
            } else {
              return Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: list(context, selectedData: selectedData),
                  ),
                  Flexible(
                    flex: 2,
                    child: detail(
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
    );
  }

  Widget detail(
    final BuildContext context, {
    required final T? selectedData,
    required final SB selectBloc,
  }) {
    return selectedData == null
        ? emptyDetail()
        : detailBuilder(
          context,
          selectedData,
          () => select(context, selectBloc: selectBloc, data: null),
        );
  }

  Widget emptyDetail() {
    return const Center(
      child: Text('Select something first'), // TODO i18n
    );
  }

  Widget list(final BuildContext context, {required final T? selectedData}) {
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
              () => select(
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

  void select(
    final BuildContext context, {
    required final SB selectBloc,
    required final T? data,
  }) {
    selectBloc.add(ActionStarted(data: data));
    context.read<MinimizedLayoutBloc>().add(ActionStarted(data: data != null));
  }
}
