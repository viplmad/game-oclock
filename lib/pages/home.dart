import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/action/action_state.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ActionState,
        Counter,
        CounterListBloc,
        CounterSelectBloc,
        LayoutTierBloc,
        LayoutTierState,
        ListLoaded;
import 'package:game_oclock/components/combine_latest_bloc_listener.dart'
    show CombineLatestBlocListener;
import 'package:game_oclock/models/models.dart' show LayoutTier, SearchDTO;

import '../components/counter_list.dart';
import '../components/list_item.dart';

class HomePageStarter extends StatelessWidget {
  const HomePageStarter({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return CounterSelectBloc();
          },
        ),
        BlocProvider(
          create:
              (_) => CounterListBloc()..add(ListLoaded(search: SearchDTO())),
        ),
      ],
      child: HomePage(
        mainDestinations: List.of([
          const NavigationDestination(icon: Icon(Icons.abc), label: '1'),
          const NavigationDestination(
            icon: Icon(Icons.app_blocking),
            label: '2',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_balance),
            label: '3',
          ),
        ], growable: false),
        secondaryDestinations: List.of([
          const NavigationDestination(
            icon: Icon(Icons.one_x_mobiledata),
            label: 'x',
          ),
          const NavigationDestination(icon: Icon(Icons.yard), label: 'y'),
          const NavigationDestination(icon: Icon(Icons.zoom_in), label: 'z'),
        ], growable: false),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
    required this.mainDestinations,
    required this.secondaryDestinations,
  });

  final List<NavigationDestination> mainDestinations;
  final List<NavigationDestination> secondaryDestinations;

  bool dialogMounted = false;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LayoutTierBloc, LayoutTierState>(
      builder: (final context, final layoutState) {
        final layoutTier = layoutState.tier;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Title'), // TODO take from navigation
            // TODO actions search
          ),
          body: CombineLatestBlocListener<
            LayoutTierBloc,
            LayoutTierState,
            CounterSelectBloc,
            ActionState<Counter?>
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
                      ? (selectState as ActionFinal<Counter?>).data
                      : null;
              if (layoutTier == LayoutTier.compact) {
                if (selectedData != null) {
                  // TODO fullscreen dialog
                  final selectBloc = context.read<CounterSelectBloc>();
                  dialogMounted = true;
                  showDialog(
                    context: context,
                    builder: (final context) {
                      return Dialog.fullscreen(
                        child: detail(selectBloc, selectedData),
                      );
                    },
                  ).whenComplete(() => dialogMounted = false);
                } else {
                  dismountDialog(context);
                }
              } else {
                dismountDialog(context);
              }
            },
            child: BlocBuilder<CounterSelectBloc, ActionState<Counter?>>(
              builder: (final context, final selectState) {
                final selectedData =
                    (selectState is ActionFinal)
                        ? (selectState as ActionFinal<Counter?>).data
                        : null;
                if (layoutTier == LayoutTier.compact) {
                  return list(selectedData);
                } else if (layoutTier == LayoutTier.medium ||
                    layoutTier == LayoutTier.expanded) {
                  return Row(
                    children: [
                      navigationRail(extended: false),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(flex: 4, child: list(selectedData)),
                            Flexible(
                              flex: 2,
                              child: detail(
                                context.read<CounterSelectBloc>(),
                                selectedData,
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
                            Flexible(flex: 4, child: list(selectedData)),
                            Flexible(
                              flex: 2,
                              child: detail(
                                context.read<CounterSelectBloc>(),
                                selectedData,
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

  void dismountDialog(final BuildContext context) async {
    if (dialogMounted) {
      Navigator.maybePop(context);
    }
  }

  FloatingActionButton fab({required final bool extended}) {
    return FloatingActionButton(
      isExtended: extended,
      onPressed: () {
        // TODO move to create page / open create dialog to search from igdb
      },
    );
  }

  NavigationDrawer navigationDrawer() {
    return NavigationDrawer(
      children: secondaryDestinations
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
    final CounterSelectBloc selectBloc,
    final Counter? selectedData,
  ) {
    return selectedData == null
        ? emptyDetail()
        : Scaffold(
          appBar: AppBar(
            title: Text(selectedData.name),
            automaticallyImplyLeading: false,
            leading: BackButton(
              onPressed: () => selectBloc.add(ActionStarted(data: null)),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              bottom: 24.0,
              left: 24.0,
              right: 24.0,
            ),
            child: SingleChildScrollView(
              child: Text(selectedData.data.toString()),
            ),
          ),
        );
  }

  Widget emptyDetail() {
    return const Center(
      child: Text('Select something first'), // TODO i18n
    );
  }

  // TODO Move to component
  GridList list(final Counter? selectedData) {
    return GridList(
      itemBuilder:
          (final context, final counter) => ListItemGrid(
            title: '${counter.name} ${counter.data}',
            onTap:
                () => {
                  context.read<CounterSelectBloc>().add(
                    ActionStarted(
                      data:
                          counter == selectedData
                              ? null // Remove selection if pressed on the same one
                              : counter,
                    ),
                  ),
                },
          ),
    );
  }
}
