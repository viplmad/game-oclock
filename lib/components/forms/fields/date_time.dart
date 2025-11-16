import 'package:flutter/material.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'date.dart';
import 'time.dart';

class SimpleDateTimeFormField extends StatelessWidget {
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
  Widget build(final BuildContext context) {
    final dateController = FormControl<DateTime>(value: formControl.value);
    final timeController = FormControl<TimeOfDay>(
      value: formControl.value == null
          ? null
          : TimeOfDay.fromDateTime(formControl.value!),
    );

    dateController.valueChanges.listen((final value) {
      final date = (formControl.value ?? DateTime.now()).copyWith(
        day: value?.day,
        month: value?.month,
        year: value?.year,
      );
      formControl.value = date;
    }); // TODO close
    timeController.valueChanges.listen((final value) {
      final date = (formControl.value ?? DateTime.now()).copyWith(
        hour: value?.hour,
        minute: value?.minute,
      );
      formControl.value = date;
    }); // TODO close

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: SimpleDateFormField(
            formControl: dateController,
            label: label,
            readOnly: readOnly,
            firstDate: firstDate,
            lastDate: lastDate,
          ),
        ),
        Expanded(
          flex: 2,
          child: SimpleTimeFormField(
            formControl: timeController,
            label: context.localize().timeLabel,
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }
}
