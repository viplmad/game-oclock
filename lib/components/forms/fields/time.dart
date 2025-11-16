import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'text.dart';

class SimpleTimeFormField extends StatefulWidget {
  const SimpleTimeFormField({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
  });

  final FormControl<TimeOfDay> formControl;
  final String label;
  final bool readOnly;

  @override
  State<SimpleTimeFormField> createState() => _SimpleTimeFormFieldState();
}

class _SimpleTimeFormFieldState extends State<SimpleTimeFormField> {
  late final FormControl<String> textFormControl;

  @override
  void initState() {
    textFormControl = FormControl<String>(
      value: _buildTextValue(widget.formControl.value),
      validators: widget.formControl.validators,
    );
    textFormControl.setErrors(widget.formControl.errors, markAsDirty: false);

    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return SimpleTextFormField(
      formControl: textFormControl,
      label: widget.label,
      readOnly: false,
      onCleared: () {
        widget.formControl.value = null;
        textFormControl.setErrors(widget.formControl.errors);
      },
      suffixIcons: [
        IconButton(
          tooltip: context.localize().showTimePicker,
          icon: CommonIcons.timePicker,
          onPressed: widget.readOnly ? null : () async => _showPicker(),
        ),
      ],
      onTap: widget.readOnly ? null : () async => _showPicker(),
    );
  }

  Future<void> _showPicker() {
    return showTimePicker(
      context: context,
      initialTime: widget.formControl.value ?? TimeOfDay.now(),
    ).then<void>((final value) {
      if (value != null) {
        widget.formControl.value = value;

        textFormControl.value = _buildTextValue(value);
        textFormControl.setErrors(widget.formControl.errors);
      }
    });
  }

  String? _buildTextValue(final TimeOfDay? value) {
    if (value == null) {
      return null;
    }

    return MaterialLocalizations.of(context).formatTimeOfDay(value);
  }
}
