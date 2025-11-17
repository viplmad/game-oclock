import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show OptionTextField;
import 'package:reactive_forms/reactive_forms.dart';

class SimpleChoiceFormField extends StatelessWidget {
  const SimpleChoiceFormField({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
    required this.options,
  });

  final FormControl<String> formControl;
  final bool readOnly;
  final String label;
  final List<OptionTextField<String>> options;

  @override
  Widget build(final BuildContext context) {
    return ReactiveValueListenableBuilder(
      formControl: formControl,
      builder: (final context, _, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: options
            .map(
              (final field) => ChoiceChip(
                label: Text(field.labelBuilder(context)),
                selected: field.value == formControl.value,
                onSelected: (final newChoice) {
                  if (newChoice) {
                    formControl.value = field.value;
                  }
                },
                selectedColor: field.color,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
