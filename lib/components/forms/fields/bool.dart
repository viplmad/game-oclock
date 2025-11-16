import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'common.dart';

class SimpleBoolFormField extends StatefulWidget {
  const SimpleBoolFormField({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
  });

  final FormControl<bool> formControl;
  final String label;
  final bool readOnly;

  @override
  State<SimpleBoolFormField> createState() => _SimpleBoolFormFieldState();
}

class _SimpleBoolFormFieldState extends State<SimpleBoolFormField> {
  @override
  Widget build(final BuildContext context) {
    return ReactiveSwitchListTile(
      formControl: widget.formControl,
      title: FormFieldLabel(text: widget.label),
      // TODO readOnly
    );
  }
}
