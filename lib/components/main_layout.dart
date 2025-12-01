import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionState, ActionSuccess, MinimizedLayoutBloc;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier, NavDestination;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:go_router/go_router.dart';

class MainLayoutBuilder extends StatelessWidget {
  const MainLayoutBuilder({
    super.key,
    required this.selectedPath,
    required this.mainDestinations,
    required this.secondaryDestinations,
    required this.child,
  });

  final String selectedPath;
  final List<NavDestination> mainDestinations;
  final List<NavDestination> secondaryDestinations; // TODO grouping
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return BlocBuilder<MinimizedLayoutBloc, ActionState<bool>>(
      builder: (final context, final minimizedState) {
        final minimized = (minimizedState is ActionSuccess<bool, bool>)
            ? minimizedState.data
            : false;
        return layoutTier == LayoutTier.compact && minimized
            ? Scaffold(body: child)
            : Scaffold(
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

  Widget navigationDrawer(
    final BuildContext context, {
    required final String selectedPath,
  }) {
    final destinations = [...mainDestinations, ...secondaryDestinations];
    return RouterNavigationDrawer(
      selectedPath: selectedPath,
      destinations: destinations,
    );
  }

  Widget navigationRail(
    final BuildContext context, {
    required final String selectedPath,
    required final bool extended,
  }) {
    return RouterNavigationRail(
      // Force extend change on tier change
      key: Key(extended.toString()),
      selectedPath: selectedPath,
      mainDestinations: mainDestinations,
      secondaryDestinations: secondaryDestinations,
      extended: extended,
    );
  }

  Widget navigationBar(
    final BuildContext context, {
    required final String selectedPath,
  }) {
    return RouterNavigationBar(
      selectedPath: selectedPath,
      destinations: mainDestinations,
    );
  }
}

ValueChanged<int> _goToSelectedPathCallback(
  final BuildContext context, {
  required final List<NavDestination> destinations,
}) {
  return (final selectedIndex) {
    final selectedDest = destinations.elementAt(selectedIndex);
    GoRouter.of(context).go(selectedDest.path);
    Scaffold.of(context).closeDrawer();
  };
}

int? _selectedIndex({
  required final String selectedPath,
  required final List<NavDestination> destinations,
}) {
  final destinationIndex = destinations.indexWhere(
    (final dest) => selectedPath.startsWith(dest.path),
  );
  return destinationIndex >= 0 ? destinationIndex : null;
}

class RouterNavigationDrawer extends StatelessWidget {
  const RouterNavigationDrawer({
    super.key,
    required this.selectedPath,
    required this.destinations,
  });

  final String selectedPath;
  final List<NavDestination> destinations;

  @override
  Widget build(final BuildContext context) {
    return NavigationDrawer(
      selectedIndex: _selectedIndex(
        selectedPath: selectedPath,
        destinations: destinations,
      ),
      onDestinationSelected: _goToSelectedPathCallback(
        context,
        destinations: destinations,
      ),
      children: destinations
          .map(
            (final dest) => NavigationDrawerDestination(
              icon: dest.icon,
              label: Text(dest.labelBuilder(context)),
            ),
          )
          .toList(growable: false),
    );
  }
}

class RouterNavigationBar extends StatelessWidget {
  const RouterNavigationBar({
    super.key,
    required this.selectedPath,
    required this.destinations,
  });

  final String selectedPath;
  final List<NavDestination> destinations;

  @override
  Widget build(final BuildContext context) {
    return NavigationBar(
      destinations: destinations
          .map(
            (final dest) => NavigationDestination(
              icon: dest.icon,
              label: dest.labelBuilder(context),
            ),
          )
          .toList(growable: false),
      selectedIndex:
          _selectedIndex(
            selectedPath: selectedPath,
            destinations: destinations,
          ) ??
          0,
      onDestinationSelected: _goToSelectedPathCallback(
        context,
        destinations: destinations,
      ),
    );
  }
}

class RouterNavigationRail extends StatefulWidget {
  const RouterNavigationRail({
    super.key,
    required this.selectedPath,
    required this.mainDestinations,
    required this.secondaryDestinations,
    required this.extended,
  });

  final List<NavDestination> mainDestinations;
  final List<NavDestination> secondaryDestinations;
  final bool extended;
  final String selectedPath;

  @override
  State<RouterNavigationRail> createState() => _RouterNavigationRailState();
}

class _RouterNavigationRailState extends State<RouterNavigationRail> {
  bool? _extended;

  @override
  Widget build(final BuildContext context) {
    final bool extended = _extended ?? widget.extended;

    final destinations = (extended
        ? [...widget.mainDestinations, ...widget.secondaryDestinations]
        : [
            ...widget.mainDestinations,
            ...widget.secondaryDestinations.where(
              (final dest) => dest.path == widget.selectedPath,
            ),
          ]);

    return NavigationRail(
      leading: IconButton(
        icon: extended ? CommonIcons.drawerOpen : CommonIcons.drawer,
        tooltip: extended
            ? MaterialLocalizations.of(context).closeButtonTooltip
            : context.localize().openLabel,
        onPressed: () {
          if (Scaffold.of(context).hasDrawer) {
            Scaffold.of(context).openDrawer();
          } else {
            setState(() {
              _extended = !extended;
            });
          }
        },
      ),
      destinations: destinations
          .map(
            (final dest) => NavigationRailDestination(
              icon: dest.icon,
              label: Text(dest.labelBuilder(context)),
            ),
          )
          .toList(growable: false),
      extended: extended,
      labelType: extended ? null : NavigationRailLabelType.all,
      selectedIndex: _selectedIndex(
        selectedPath: widget.selectedPath,
        destinations: destinations,
      ),
      onDestinationSelected: _goToSelectedPathCallback(
        context,
        destinations: destinations,
      ),
    );
  }
}
