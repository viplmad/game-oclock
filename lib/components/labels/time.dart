import 'package:flutter/material.dart';

import 'text.dart';

class TimeLabel extends StatelessWidget {
  const TimeLabel({super.key, required this.label, required this.value});

  final String label;
  final DateTime? value;

  @override
  Widget build(final BuildContext context) {
    return TextLabel(
      label: label,
      value: value == null
          ? null
          : MaterialLocalizations.of(
              context,
            ).formatTimeOfDay(TimeOfDay.fromDateTime(value!)),
    );
  }
}
