import 'package:flutter/material.dart';

import 'generic_field.dart';

class TimeField extends StatelessWidget {
  const TimeField({
    super.key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.onLongPress,
    this.update,
  });

  final String fieldName;
  final TimeOfDay? value;
  final bool editable;
  final void Function()? onLongPress;
  final void Function(TimeOfDay)? update;

  @override
  Widget build(BuildContext context) {
    return GenericField<TimeOfDay>(
      fieldName: fieldName,
      value: value,
      shownValue: value != null
          ? MaterialLocalizations.of(context)
              .formatTimeOfDay(value!, alwaysUse24HourFormat: true)
          : null,
      editable: editable,
      update: update,
      onTap: () async {
        return showTimePicker(
          context: context,
          initialTime: value ?? TimeOfDay.now(),
        );
      },
      onLongPress: onLongPress,
    );
  }
}
