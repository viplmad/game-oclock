import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'common.dart';

class SimpleBoolFormField extends StatelessWidget {
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
  Widget build(final BuildContext context) {
    return ReactiveValueListenableBuilder(
      formControl: formControl,
      builder: (_, _, _) => SwitchListTile(
        value: formControl.value ?? false,
        onChanged: readOnly ? null : (final value) => formControl.value = value,
        title: FormFieldLabel(text: label),
      ),
    );
  }
}
