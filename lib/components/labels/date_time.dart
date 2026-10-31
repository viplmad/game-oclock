import 'package:flutter/material.dart';

import 'text.dart';

class DateTimeLabel extends StatelessWidget {
  const DateTimeLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Widget icon;
  final String label;
  final DateTime? value;

  @override
  Widget build(BuildContext context) {
    return TextLabel(
      icon: icon,
      label: label,
      value: value == null
          ? null
          : MaterialLocalizations.of(context).formatFullDate(value!),
    );
  }
}
