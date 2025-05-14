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
        ListQuicksearchChanged;
import 'package:game_oclock/models/models.dart' show LayoutTier;

import 'grid_list.dart';

class ListDetailLayoutBuilder<
  T,
  SB extends FunctionActionBloc<T?, T?>,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  const ListDetailLayoutBuilder({
    super.key,
    required this.filterSpace,
    required this.title,
    required this.mainDestinations,
    required this.secondaryDestinations,
    required this.actions,
    required this.fabLabel,
    required this.fabIcon,
    required this.fabOnPressed,
    required this.detailBuilder,
    required this.listItemBuilder,
  });

  final String title;
  final String filterSpace;
  final List<NavigationDestination> mainDestinations;
  final List<NavigationDestination> secondaryDestinations;
  final List<Widget> actions;

  final String fabLabel;
  final Icon fabIcon;
  final VoidCallback fabOnPressed;

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
                    ? (selectState as ActionFinal<T?>).data
                    : null;
            if (layoutTier == LayoutTier.compact) {
              if (selectedData != null) {
                return detail(
                  context,
                  selectedData: selectedData,
                  selectBloc: context.read<SB>(),
                );
              }
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(title),
                actions: [
                  SearchAnchor(
                    builder: (final context, final controller) {
                      return IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          controller.openView();
                        },
                      );
                    },
                    suggestionsBuilder:
                        (final context, final controller) => List.empty(),
                    viewOnChanged: // TODO not called
                        (final value) => context.read<LB>().add(
                          ListQuicksearchChanged(quicksearch: value),
                        ),
                  ),
                ],
              ),
              body: BlocBuilder<SB, ActionState<T?>>(
                builder: (final context, final selectState) {
                  final selectedData =
                      (selectState is ActionFinal)
                          ? (selectState as ActionFinal<T?>).data
                          : null;
                  if (layoutTier == LayoutTier.compact) {
                    return list(context, selectedData: selectedData);
                  } else if (layoutTier == LayoutTier.medium ||
                      layoutTier == LayoutTier.expanded) {
                    return Row(
                      children: [
                        navigationRail(extended: false),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 4,
                                child: list(
                                  context,
                                  selectedData: selectedData,
                                ),
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
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        navigationRail(extended: true),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 4,
                                child: list(
                                  context,
                                  selectedData: selectedData,
                                ),
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
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              bottomNavigationBar:
                  layoutTier == LayoutTier.compact ? navigationBar() : null,
              drawer:
                  layoutTier == LayoutTier.compact ||
                          layoutTier == LayoutTier.medium ||
                          layoutTier == LayoutTier.expanded
                      ? navigationDrawer()
                      : null,
              floatingActionButton:
                  layoutTier == LayoutTier.compact
                      ? fab(extended: false)
                      : null,
            );
          },
        );
      },
    );
  }

  FloatingActionButton fab({required final bool extended}) {
    return extended
        ? FloatingActionButton.extended(
          label: Text(fabLabel),
          icon: fabIcon,
          onPressed: fabOnPressed,
        )
        : FloatingActionButton(
          tooltip: fabLabel,
          onPressed: fabOnPressed,
          child: fabIcon,
        );
  }

  NavigationDrawer navigationDrawer() {
    return NavigationDrawer(
      children: [...mainDestinations, ...secondaryDestinations] // TODO group
          .map(
            (final dest) => NavigationDrawerDestination(
              icon: dest.icon,
              label: Text(dest.label),
            ),
          )
          .toList(growable: false),
    );
  }

  NavigationRail navigationRail({required final bool extended}) {
    return NavigationRail(
      leading: fab(extended: extended),
      destinations: (extended
              ? [...mainDestinations, ...secondaryDestinations] // TODO group
              : mainDestinations)
          .map(
            (final dest) => NavigationRailDestination(
              icon: dest.icon,
              label: Text(dest.label),
            ),
          )
          .toList(growable: false),
      extended: extended,
      selectedIndex: 0,
    );
  }

  NavigationBar navigationBar() {
    return NavigationBar(destinations: mainDestinations);
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
          () => selectBloc.add(ActionStarted(data: null)),
        );
  }

  Widget emptyDetail() {
    return const Center(
      child: Text('Select something first'), // TODO i18n
    );
  }

  Widget list(final BuildContext context, {required final T? selectedData}) {
    return GridListBuilder<T, LB>(
      space: filterSpace,
      itemBuilder:
          (final context, final data) => listItemBuilder(
            context,
            data,
            () => context.read<SB>().add(
              ActionStarted(
                data:
                    data == selectedData
                        ? null // Remove selection if pressed on the same one
                        : data,
              ),
            ),
          ),
    );
  }
}
