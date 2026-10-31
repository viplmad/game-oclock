import 'package:flutter/material.dart';

final class NavDestination {
  final Widget icon;
  final String Function(BuildContext context) labelBuilder;
  final String path;
  final List<String> guardRoles;

  const NavDestination({
    required this.icon,
    required this.labelBuilder,
    required this.path,
    required this.guardRoles,
  });
}

final class TabDestination extends ActionDestination {
  final Widget child;

  const TabDestination({
    required super.icon,
    required super.labelBuilder,
    required super.onTap,
    required this.child,
  });
}

final class ActionDestination {
  final Widget icon;
  final String Function(BuildContext context) labelBuilder;
  final ValueChanged<BuildContext> onTap;

  const ActionDestination({
    required this.icon,
    required this.labelBuilder,
    required this.onTap,
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
  }) : super(widgetBuilder: (context) => Text(labelBuilder(context)));
}

enum FieldType { text, integer, bool, duration, datetime, options }

final class OptionDynamicField<T> extends OptionTextField<T> {
  final FieldType type;

  OptionDynamicField({
    super.icon,
    required super.labelBuilder,
    required super.value,
    required this.type,
    super.color,
  });
}
