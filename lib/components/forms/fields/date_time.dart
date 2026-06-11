import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'text.dart';

class SimpleDateTimeFormField extends StatefulWidget {
  const SimpleDateTimeFormField({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
    required this.firstDate,
    required this.lastDate,
  });

  final FormControl<DateTime> formControl;
  final String label;
  final bool readOnly;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<SimpleDateTimeFormField> createState() =>
      _SimpleDateTimeFormFieldState();
}

class _SimpleDateTimeFormFieldState extends State<SimpleDateTimeFormField> {
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
          tooltip: context.localize().showDatePicker,
          icon: CommonIcons.datePicker,
          onPressed: widget.readOnly ? null : () async => _showPicker(),
        ),
      ],
      onTap: widget.readOnly ? null : () async => _showPicker(),
    );
  }

  Future<void> _showPicker() {
    return showDatePicker(
      context: context,
      initialDate: widget.formControl.value ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    ).then<void>((final dateValue) {
      if (dateValue != null && context.mounted) {
        return showTimePicker(
          context: context,
          initialTime: widget.formControl.value == null
              ? TimeOfDay.now()
              : TimeOfDay.fromDateTime(widget.formControl.value!),
        ).then<void>((final timeValue) {
          if (timeValue != null) {
            final value = dateValue.copyWith(
              hour: timeValue.hour,
              minute: timeValue.minute,
            );

            widget.formControl.value = value;

            textFormControl.value = _buildTextValue(value);
            textFormControl.setErrors(widget.formControl.errors);
          }
        });
      }
    });
  }

  String? _buildTextValue(final DateTime? value) {
    if (value == null) {
      return null;
    }

    return '${MaterialLocalizations.of(context).formatCompactDate(value)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(value))}';
  }
}
