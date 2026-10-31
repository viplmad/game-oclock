import 'package:flutter/material.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'text.dart';

class DurationLabel extends StatelessWidget {
  const DurationLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Widget icon;
  final String label;
  final Duration? value;

  @override
  Widget build(BuildContext context) {
    return TextLabel(
      icon: icon,
      label: label,
      value: value == null ? '0' : context.localize().formatDuration(value!),
    );
  }
}
