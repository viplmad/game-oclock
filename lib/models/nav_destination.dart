import 'package:flutter/material.dart';

final class NavDestination {
  final Widget icon;
  final String Function(BuildContext context) labelBuilder;
  final String path;

  const NavDestination({
    required this.icon,
    required this.labelBuilder,
    required this.path,
  });
}

final class TabDestination {
  final Widget icon;
  final String label;
  final ValueChanged<BuildContext> onTap;
  final Widget child;

  const TabDestination({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.child,
  });
}
