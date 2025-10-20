import 'package:flutter/material.dart';

class LabelChip extends StatelessWidget {
  const LabelChip({super.key, required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    return IgnorePointer(
      child: ActionChip(
        label: Text(label),
        backgroundColor: color,
        onPressed: () => {},
      ),
    );
  }
}
