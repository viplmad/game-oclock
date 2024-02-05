import 'package:flutter/material.dart';

import '../year_picker_dialog.dart';
import 'generic_field.dart';

class YearField extends StatelessWidget {
  const YearField({
    super.key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.onLongPress,
    this.update,
  });

  final String fieldName;
  final int? value;
  final bool editable;
  final void Function()? onLongPress;
  final void Function(int)? update;

  @override
  Widget build(BuildContext context) {
    return GenericField<int>(
      fieldName: fieldName,
      value: value,
      shownValue: value?.toString(), // No need for intl
      editable: editable,
      update: update,
      onTap: () async {
        return showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return YearPickerDialog(
              year: value,
            );
          },
        );
      },
      onLongPress: onLongPress,
    );
  }
}
