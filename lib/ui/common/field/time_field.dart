import 'package:flutter/material.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'generic_field.dart';


class TimeField extends StatelessWidget{
  const TimeField({
    Key? key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.update,
  }) : super(key: key);

  final String fieldName;
  final TimeOfDay? value;
  final bool editable;
  final void Function(TimeOfDay)? update;

  @override
  Widget build(BuildContext context) {

    return GenericField<TimeOfDay>(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
        GameCollectionLocalisations.of(context).formatTimeOfDay(value!)
        : null,
      editable: editable,
      update: update,
      onTap: () {
        return showTimePicker(
          context: context,
          initialTime: value?? TimeOfDay.now(),
        );
      },
    );

  }
}