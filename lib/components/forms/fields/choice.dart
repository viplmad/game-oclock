import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DropdownField;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

import 'label.dart';

class SimpleChoiceFormField extends StatelessWidget {
  const SimpleChoiceFormField({
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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceAround,
      children: options
          .map(
            (final field) => ChoiceChip(
              label: Text(field.labelBuilder(context)),
              selected: field.value == controller.text,
              onSelected: (final newChoice) {
                if (newChoice) {
                  controller.setValue(field.value);
                }
              },
              selectedColor: field.color,
            ),
          )
          .toList(growable: false),
    );
  }
}
