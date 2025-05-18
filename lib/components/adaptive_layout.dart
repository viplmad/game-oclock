import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show LayoutTierBloc, LayoutTierState;
import 'package:game_oclock/models/models.dart' show LayoutTier;

class AdaptiveLayoutBuilder extends StatelessWidget {
  const AdaptiveLayoutBuilder({
    super.key,
    required this.title,
    required this.minimized,
    required this.mainDestinations,
    required this.secondaryDestinations,
    required this.actions,
    required this.fabLabel,
    required this.fabIcon,
    required this.fabOnPressed,
    required this.child,
  });

  final String title;
  final bool minimized;
  final List<NavigationDestination> mainDestinations;
  final List<NavigationDestination> secondaryDestinations;
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

        return layoutTier == LayoutTier.compact && minimized
            ? Scaffold(body: child)
            : Scaffold(
              appBar: AppBar(title: Text(title), actions: actions),
              body: body(layoutTier: layoutTier),
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
  }

  Widget body({required final LayoutTier layoutTier}) {
    if (layoutTier == LayoutTier.compact) {
      return child;
    } else if (layoutTier == LayoutTier.medium ||
        layoutTier == LayoutTier.expanded) {
      return Row(
        children: [navigationRail(extended: false), Expanded(child: child)],
      );
    } else {
      return Row(
        children: [navigationRail(extended: true), Expanded(child: child)],
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
}
