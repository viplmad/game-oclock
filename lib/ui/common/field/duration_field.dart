import 'package:flutter/material.dart';

import 'package:duration_picker/duration_picker.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'generic_field.dart';


class DurationField extends StatelessWidget {
  const DurationField({
    Key? key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.update,
  }) : super(key: key);

  final String fieldName;
  final Duration? value;
  final bool editable;
  final void Function(Duration)? update;

  @override
  Widget build(BuildContext context) {

    return GenericField<Duration>(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
        GameCollectionLocalisations.of(context).formatDuration(value!)
        : null,
      editable: editable,
      update: update,
      onTap: () {
        return showDurationPicker(
          context: context,
          snapToMins: 5.0,
          initialTime: value?? Duration.zero,
        );
      },
    );

  }
}