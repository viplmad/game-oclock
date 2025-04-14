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
        ListLoadBloc;
import 'package:game_oclock/components/combine_latest_bloc_listener.dart'
    show CombineLatestBlocListener;
import 'package:game_oclock/models/models.dart' show LayoutTier;

import 'grid_list.dart';

class ListDetailLayout<
  T,
  SB extends FunctionActionBloc<T?, T?>,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  ListDetailLayout({
    super.key,
    required this.mainDestinations,
    required this.secondaryDestinations,
    required this.title,
    required this.fabLabel,
    required this.fabIcon,
    required this.fabOnPressed,
    required this.detailBuilder,
    required this.listItemBuilder,
  });

  final String title;
  final List<NavigationDestination> mainDestinations;
  final List<NavigationDestination> secondaryDestinations;

  final String fabLabel;
  final Icon fabIcon;
  final VoidCallback fabOnPressed;

  final Widget Function(BuildContext context, T data, VoidCallback onClosed)
  detailBuilder;
  final Widget Function(BuildContext context, T data, VoidCallback onPressed)
  listItemBuilder;

  bool dialogMounted = false;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LayoutTierBloc, LayoutTierState>(
      builder: (final context, final layoutState) {
        final layoutTier = layoutState.tier;

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            // TODO actions search
          ),
          body: CombineLatestBlocListener<
            LayoutTierBloc,
            LayoutTierState,
            SB,
            ActionState<T?>
          >(
            // ignore: prefer_final_parameters
            listenWhen: (_, __, ___, final current) => current is ActionFinal,
            listener: (
              final context,
              final layoutState,
              final selectState,
            ) async {
              final layoutTier = layoutState.tier;
              final selectedData =
                  (selectState is ActionFinal)
                      ? (selectState as ActionFinal<T?>).data
                      : null;
              if (layoutTier == LayoutTier.compact) {
                if (selectedData != null) {
                  final selectBloc = context.read<SB>();
                  dialogMounted = true;
                  showDialog(
                    context: context,
                    builder: (final context) {
                      return Dialog.fullscreen(
                        child: detail(
                          context,
                          selectedData: selectedData,
                          selectBloc: selectBloc,
                        ),
                      );
                    },
                  ).whenComplete(() => dialogMounted = false);
                } else {
                  dismountDetailDialog(context);
                }
              } else {
                dismountDetailDialog(context);
              }
            },
            child: BlocBuilder<SB, ActionState<T?>>(
              builder: (final context, final selectState) {
                final selectedData =
                    (selectState is ActionFinal)
                        ? (selectState as ActionFinal<T?>).data
                        : null;
                if (layoutTier == LayoutTier.compact) {
                  return list(selectedData: selectedData);
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
                              child: list(selectedData: selectedData),
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
                              child: list(selectedData: selectedData),
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
              layoutTier == LayoutTier.compact ? fab(extended: false) : null,
        );
      },
    );
  }

  void dismountDetailDialog(final BuildContext context) async {
    if (dialogMounted) {
      Navigator.maybePop(context);
    }
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

  Widget list({required final T? selectedData}) {
    return GridList<T, LB>(
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
