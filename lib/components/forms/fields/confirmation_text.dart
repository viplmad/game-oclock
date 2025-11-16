import 'package:flutter/material.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'text.dart';

class SimpleConfirmationTextFormField extends StatelessWidget {
  const SimpleConfirmationTextFormField({
    super.key,
    required this.formControl,
    required this.confirmationFormControl,
    required this.label,
    this.readOnly = false,
  });

  final FormControl<String> formControl;
  final FormControl<String> confirmationFormControl;
  final String label;
  final bool readOnly;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SimpleObscuredTextFormField(
            formControl: formControl,
            label: label,
            readOnly: readOnly,
          ),
        ),
        Expanded(
          child: SimpleObscuredTextFormField(
            formControl: confirmationFormControl,
            label: context.localize().confirmationLabel,
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }
}
