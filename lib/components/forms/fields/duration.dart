import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'text.dart';

class SimpleDurationFormField extends StatefulWidget {
  const SimpleDurationFormField({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
  });

  final FormControl<Duration> formControl;
  final String label;
  final bool readOnly;

  @override
  State<SimpleDurationFormField> createState() =>
      _SimpleDurationFormFieldState();
}

class _SimpleDurationFormFieldState extends State<SimpleDurationFormField> {
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
          tooltip: context.localize().showDurationPicker,
          icon: CommonIcons.durationPicker,
          onPressed: widget.readOnly ? null : () async => _showPicker(),
        ),
      ],
      onTap: widget.readOnly ? null : () async => _showPicker(),
    );
  }

  Future<void> _showPicker() {
    return showDurationPicker(
      context: context,
      initialTime: widget.formControl.value ?? Duration.zero,
    ).then<void>((final value) {
      if (value != null) {
        widget.formControl.value = value;

        textFormControl.value = _buildTextValue(value);
        textFormControl.setErrors(widget.formControl.errors);
      }
    });
  }

  String? _buildTextValue(final Duration? value) {
    if (value == null) {
      return null;
    }

    return context.localize().duration(value);
  }
}
