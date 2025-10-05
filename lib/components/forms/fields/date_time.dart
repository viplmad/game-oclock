import 'package:flutter/material.dart';

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
    final dateEditingController = DateTimeEditingController(
      date: controller.value,
    );
    final timeEditingController = TimeEditingController(
      time: controller.value == null
          ? null
          : TimeOfDay.fromDateTime(controller.value!),
    );

    dateEditingController.addListener(() {
      final date = (controller.value ?? DateTime.now()).copyWith(
        day: dateEditingController.value?.day,
        month: dateEditingController.value?.month,
        year: dateEditingController.value?.year,
      );
      controller.setValue(date);
    });
    timeEditingController.addListener(() {
      final date = (controller.value ?? DateTime.now()).copyWith(
        hour: timeEditingController.value?.hour,
        minute: timeEditingController.value?.minute,
      );
      controller.setValue(date);
    });

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: SimpleDateFormField(
            controller: dateEditingController,
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
            controller: timeEditingController,
            label: label,
            required: required,
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }
}
