import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show OptionTextField;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class SimpleChoiceFormField extends StatefulWidget {
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
  final List<OptionTextField<String>> options;

  @override
  State<SimpleChoiceFormField> createState() => _SimpleChoiceFormFieldState();
}

class _SimpleChoiceFormFieldState extends State<SimpleChoiceFormField> {
  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.options
          .map(
            (final field) => ChoiceChip(
              label: Text(field.labelBuilder(context)),
              selected: field.value == widget.controller.text,
              onSelected: (final newChoice) {
                if (newChoice) {
                  widget.controller.setValue(field.value);
                  setState(() {});
                }
              },
              selectedColor: field.color,
            ),
          )
          .toList(growable: false),
    );
  }
}
