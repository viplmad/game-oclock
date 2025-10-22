import 'package:flutter/material.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'text.dart';

class DurationLabel extends StatelessWidget {
  const DurationLabel({super.key, required this.label, required this.value});

  final String label;
  final Duration? value;

  @override
  Widget build(final BuildContext context) {
    return TextLabel(
      label: label,
      value: value == null ? '0' : context.localize().duration(value!),
    );
  }
}
