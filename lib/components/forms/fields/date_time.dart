import 'package:flutter/material.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'date.dart';
import 'time.dart';

class SimpleDateTimeFormField extends StatelessWidget {
  const SimpleDateTimeFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTimeEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(final BuildContext context) {
    final dateController = DateTimeEditingController(date: controller.value);
    final timeController = TimeEditingController(
      time: controller.value == null
          ? null
          : TimeOfDay.fromDateTime(controller.value!),
    );

    dateController.addListener(() {
      final date = (controller.value ?? DateTime.now()).copyWith(
        day: dateController.value?.day,
        month: dateController.value?.month,
        year: dateController.value?.year,
      );
      controller.setValue(date);
    });
    timeController.addListener(() {
      final date = (controller.value ?? DateTime.now()).copyWith(
        hour: timeController.value?.hour,
        minute: timeController.value?.minute,
      );
      controller.setValue(date);
    });

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: SimpleDateFormField(
            controller: dateController,
            label: label,
            required: required,
            readOnly: readOnly,
            firstDate: firstDate,
            lastDate: lastDate,
          ),
        ),
        Expanded(
          flex: 2,
          child: SimpleTimeFormField(
            controller: timeController,
            label: context.localize().timeLabel,
            required: required,
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }
}
