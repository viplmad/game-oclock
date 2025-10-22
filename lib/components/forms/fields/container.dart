import 'package:flutter/material.dart';

class FormFieldsContainer extends StatelessWidget {
  const FormFieldsContainer({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    return Column(spacing: 24.0, children: children);
  }
}
