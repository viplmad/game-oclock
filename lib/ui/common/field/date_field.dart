import 'package:flutter/material.dart';

import 'package:game_collection/ui/utils/app_localizations_utils.dart';

import '../show_date_picker.dart';
import 'generic_field.dart';

class DateField extends StatelessWidget {
  const DateField({
    Key? key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.update,
  }) : super(key: key);

  final String fieldName;
  final DateTime? value;
  final bool editable;
  final void Function(DateTime)? update;

  @override
  Widget build(BuildContext context) {
    return GenericField<DateTime>(
      fieldName: fieldName,
      value: value,
      shownValue:
          value != null ? AppLocalizationsUtils.formatDate(value!) : null,
      update: update,
      editable: editable,
      onTap: () async {
        return showGameDatePicker(
          context: context,
          initialDate: value,
        );
      },
    );
  }
}
