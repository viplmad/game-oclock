import 'package:flutter/material.dart';

class LabelChip extends StatelessWidget {
  const LabelChip({super.key, this.icon, required this.label, this.color});

  final Widget? icon;
  final String label;
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    return IgnorePointer(
      child: ActionChip(
        avatar: icon,
        label: Text(label),
        backgroundColor: color,
        onPressed: () => {},
      ),
    );
  }
}
