import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionFinal, ActionState, MinimizedLayoutBloc;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier, NavDestination;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:go_router/go_router.dart';

class MainLayoutBuilder extends StatelessWidget {
  MainLayoutBuilder({
    super.key,
    required this.selectedPath,
    required this.mainDestinations,
    required this.secondaryDestinations,
    required this.child,
  });

  final String selectedPath;
  final List<NavDestination> mainDestinations;
  final List<NavDestination> secondaryDestinations;
  final Widget child;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return BlocBuilder<MinimizedLayoutBloc, ActionState<bool>>(
      builder: (final context, final minimizedState) {
        final minimized = (minimizedState is ActionFinal)
            ? (minimizedState as ActionFinal<bool, bool>).data
            : false;
        return layoutTier == LayoutTier.compact && minimized
            ? Scaffold(body: child)
            : Scaffold(
                key: scaffoldKey,
                body: body(
                  context,
                  selectedPath: selectedPath,
                  layoutTier: layoutTier,
                ),
                bottomNavigationBar: layoutTier == LayoutTier.compact
                    ? navigationBar(context, selectedPath: selectedPath)
                    : null,
                drawer:
                    layoutTier == LayoutTier.compact ||
                        layoutTier == LayoutTier.medium ||
                        layoutTier == LayoutTier.expanded
                    ? navigationDrawer(context, selectedPath: selectedPath)
                    : null,
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
          const VerticalDivider(width: 1.0),
          Expanded(child: child),
        ],
      );
    } else {
      return Row(
        children: [
          navigationRail(context, selectedPath: selectedPath, extended: true),
          const VerticalDivider(width: 1.0),
          Expanded(child: child),
        ],
      );
    }
  }

  IconButton drawerButton() {
    return IconButton(
      icon: const Icon(CommonIcons.drawer),
      onPressed: () => scaffoldKey.currentState?.openDrawer(),
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
      children:
          destinations // TODO group
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
    final destinations = (extended
        ? [...mainDestinations, ...secondaryDestinations]
        : mainDestinations);
    return NavigationRail(
      leading: extended
          ? IconButton(
              icon: const Icon(CommonIcons.drawerOpen),
              onPressed: () {},
            )
          : drawerButton(),
      destinations:
          destinations // TODO group
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

  Widget navigationBar(
    final BuildContext context, {
    required final String selectedPath,
  }) {
    return Stack(
      children: [
        NavigationBar(
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
        ),
        Positioned(left: 10, top: 20, child: drawerButton()),
      ],
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
