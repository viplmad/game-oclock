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

final class OptionField<T> {
  final Widget? icon;
  final Widget Function(BuildContext context) widgetBuilder;
  final T value;
  final Color? color;

  const OptionField({
    this.icon,
    required this.widgetBuilder,
    required this.value,
    this.color,
  });
}

final class OptionTextField<T> extends OptionField<T> {
  final String Function(BuildContext context) labelBuilder;

  OptionTextField({
    super.icon,
    required this.labelBuilder,
    required super.value,
    super.color,
  }) : super(widgetBuilder: (final context) => Text(labelBuilder(context)));
}
