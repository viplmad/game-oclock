import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionState,
        LayoutTierBloc,
        LayoutTierState,
        MinimizedLayoutBloc;
import 'package:game_oclock/models/models.dart' show LayoutTier, NavDestination;
import 'package:go_router/go_router.dart';

class AdaptiveLayoutBuilder extends StatelessWidget {
  const AdaptiveLayoutBuilder({
    super.key,
    required this.title,
    required this.selectedPath,
    required this.mainDestinations,
    required this.secondaryDestinations,
    required this.actions,
    required this.fabLabel,
    required this.fabIcon,
    required this.fabOnPressed,
    required this.child,
  });

  final String title;
  final String selectedPath;
  final List<NavDestination> mainDestinations;
  final List<NavDestination> secondaryDestinations;
  final List<Widget> actions;
  final String fabLabel;
  final Icon fabIcon;
  final VoidCallback fabOnPressed;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LayoutTierBloc, LayoutTierState>(
      builder: (final context, final layoutState) {
        final layoutTier = layoutState.tier;

        return BlocBuilder<MinimizedLayoutBloc, ActionState<bool>>(
          builder: (final context, final minimizedState) {
            final minimized =
                (minimizedState is ActionFinal)
                    ? (minimizedState as ActionFinal<bool>).data
                    : false;

            return layoutTier == LayoutTier.compact && minimized
                ? Scaffold(body: child)
                : Scaffold(
                  appBar: AppBar(title: Text(title), actions: actions),
                  body: body(
                    context,
                    selectedPath: selectedPath,
                    layoutTier: layoutTier,
                  ),
                  bottomNavigationBar:
                      layoutTier == LayoutTier.compact
                          ? navigationBar(context, selectedPath: selectedPath)
                          : null,
                  drawer:
                      layoutTier == LayoutTier.compact ||
                              layoutTier == LayoutTier.medium ||
                              layoutTier == LayoutTier.expanded
                          ? navigationDrawer(
                            context,
                            selectedPath: selectedPath,
                          )
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

  Widget body(
    final BuildContext context, {
    required final String selectedPath,
    required final LayoutTier layoutTier,
  }) {
    if (layoutTier == LayoutTier.compact) {
      return child;
    } else if (layoutTier == LayoutTier.medium ||
        layoutTier == LayoutTier.expanded) {
      return Row(
        children: [
          navigationRail(context, selectedPath: selectedPath, extended: false),
          Expanded(child: child),
        ],
      );
    } else {
      return Row(
        children: [
          navigationRail(context, selectedPath: selectedPath, extended: true),
          Expanded(child: child),
        ],
      );
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

  NavigationDrawer navigationDrawer(
    final BuildContext context, {
    required final String selectedPath,
  }) {
    final destinations = [...mainDestinations, ...secondaryDestinations];
    return NavigationDrawer(
      selectedIndex: _selectedIndex(
        selectedPath: selectedPath,
        destinations: destinations,
      ),
      onDestinationSelected: _goToSelectedPathCallback(
        context,
        destinations: destinations,
      ),
      children: destinations // TODO group
          .map(
            (final dest) => NavigationDrawerDestination(
              icon: dest.icon,
              label: Text(dest.label),
            ),
          )
          .toList(growable: false),
    );
  }

  NavigationRail navigationRail(
    final BuildContext context, {
    required final String selectedPath,
    required final bool extended,
  }) {
    final destinations =
        (extended
            ? [...mainDestinations, ...secondaryDestinations]
            : mainDestinations);
    return NavigationRail(
      leading: fab(extended: extended),
      destinations: destinations // TODO group
          .map(
            (final dest) => NavigationRailDestination(
              icon: dest.icon,
              label: Text(dest.label),
            ),
          )
          .toList(growable: false),
      extended: extended,
      selectedIndex: _selectedIndex(
        selectedPath: selectedPath,
        destinations: destinations,
      ),
      onDestinationSelected: _goToSelectedPathCallback(
        context,
        destinations: destinations,
      ),
    );
  }

  NavigationBar navigationBar(
    final BuildContext context, {
    required final String selectedPath,
  }) {
    return NavigationBar(
      destinations: mainDestinations
          .map(
            (final dest) =>
                NavigationDestination(icon: dest.icon, label: dest.label),
          )
          .toList(growable: false),
      selectedIndex:
          _selectedIndex(
            selectedPath: selectedPath,
            destinations: mainDestinations,
          ) ??
          0,
      onDestinationSelected: _goToSelectedPathCallback(
        context,
        destinations: mainDestinations,
      ),
    );
  }

  static ValueChanged<int> _goToSelectedPathCallback(
    final BuildContext context, {
    required final List<NavDestination> destinations,
  }) {
    return (final selectedIndex) {
      final selectedDest = destinations.elementAt(selectedIndex);
      GoRouter.of(context).go(selectedDest.path);
    };
  }

  static int? _selectedIndex({
    required final String selectedPath,
    required final List<NavDestination> destinations,
  }) {
    final destinationIndex = destinations.indexWhere(
      (final dest) => selectedPath.startsWith(dest.path),
    );
    return destinationIndex >= 0 ? destinationIndex : null;
  }
}
