import 'package:flutter/material.dart';

import 'package:duration_picker/duration_picker.dart';

import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import 'generic_field.dart';

class DurationField extends StatelessWidget {
  const DurationField({
    super.key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.update,
  });

  final String fieldName;
  final Duration? value;
  final bool editable;
  final void Function(Duration)? update;

  @override
  Widget build(BuildContext context) {
    return GenericField<Duration>(
      fieldName: fieldName,
      value: value,
      shownValue: value != null
          ? AppLocalizationsUtils.formatDuration(context, value!)
          : null,
      editable: editable,
      update: update,
      onTap: () async {
        return showDurationPicker(
          context: context,
          initialTime: value ?? Duration.zero,
        );
      },
    );
  }
}
