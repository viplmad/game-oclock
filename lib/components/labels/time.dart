import 'package:flutter/material.dart';
import 'package:game_oclock/models/date_locale_config.dart';

import 'text.dart';

class TimeLabel extends StatelessWidget {
  const TimeLabel({
    super.key,
    required this.label,
    required this.value,
    required this.dateConfig,
  });

  final String label;
  final DateTime? value;
  final DateLocaleConfig dateConfig;

  @override
  Widget build(final BuildContext context) {
    return TextLabel(
      label: label,
      value: value == null ? null : dateConfig.timeFormat.format(value!),
    );
  }
}
