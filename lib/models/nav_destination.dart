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
  final String Function(BuildContext context) labelBuilder;
  final ValueChanged<BuildContext> onTap;
  final Widget child;

  const TabDestination({
    required this.icon,
    required this.labelBuilder,
    required this.onTap,
    required this.child,
  });
}

final class DropdownField {
  final String value;
  final String Function(BuildContext context) labelBuilder;

  const DropdownField({required this.value, required this.labelBuilder});
}
