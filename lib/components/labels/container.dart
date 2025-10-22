import 'package:flutter/material.dart';

class LabelsContainer extends StatelessWidget {
  const LabelsContainer({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    return Column(spacing: 0.0, children: children);
  }
}
