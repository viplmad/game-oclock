import 'package:flutter/material.dart';
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'text.dart';

class SimpleConfirmationTextFormField extends StatelessWidget {
  const SimpleConfirmationTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;

  @override
  Widget build(final BuildContext context) {
    final confirmationController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: SimpleObscuredTextFormField(
            controller: controller,
            label: label,
            required: required,
            readOnly: readOnly,
          ),
        ),
        Expanded(
          child: SimpleObscuredTextFormField(
            controller: confirmationController,
            label: context.localize().confirmationLabel,
            required: required,
            readOnly: readOnly,
            validator: (final value) =>
                notEqualValidator(context, value, controller.text),
          ),
        ),
      ],
    );
  }
}
