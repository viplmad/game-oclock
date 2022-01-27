import 'package:flutter/material.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../year_picker_dialog.dart';
import 'generic_field.dart';


class YearField extends StatelessWidget {
  const YearField({
    Key? key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.update,
  }) : super(key: key);

  final String fieldName;
  final int? value;
  final bool editable;
  final void Function(int)? update;

  @override
  Widget build(BuildContext context) {

    return GenericField<int>(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
        GameCollectionLocalisations.of(context).formatYear(value!)
        : null,
      editable: editable,
      update: update,
      onTap: () {
        return showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return YearPickerDialog(
              year: value,
            );
          },
        );
      },
    );

  }
}