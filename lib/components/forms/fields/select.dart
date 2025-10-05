import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DropdownField;

import 'common.dart';

class SimpleSelectFormField extends StatelessWidget {
  const SimpleSelectFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    required this.options,
  });

  final TextEditingController controller;
  final bool required;
  final bool readOnly;
  final String label;
  final List<DropdownField> options;

  @override
  Widget build(final BuildContext context) {
    return DropdownMenu<String>(
      enabled: !readOnly,
      controller: controller,
      enableFilter: true,
      requestFocusOnTap: true,
      label: FormFieldLabel(text: label, required: required),
      /*trailingIcon: readOnly || controller.text.isEmpty
          ? null
          : ClearIconButton(onTap: () => controller.clear()),*/
      // TODO required validator errorText: 'malo malo',
      dropdownMenuEntries: options
          .map(
            (final field) => DropdownMenuEntry<String>(
              value: field.value,
              label: field.labelBuilder(context),
            ),
          )
          .toList(growable: false),
    );
  }
}
