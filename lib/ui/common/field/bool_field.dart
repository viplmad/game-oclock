import 'package:flutter/material.dart';


class BoolField extends StatelessWidget {
  const BoolField({
    Key? key,
    required this.fieldName,
    required this.value,
    this.editable = true,
    this.update,
  }) : super(key: key);

  final String fieldName;
  final bool? value;
  final bool editable;
  final Function(bool)? update;

  @override
  Widget build(BuildContext context) {

    return SwitchListTile(
      title: Text(fieldName),
      value: value?? false,
      onChanged: editable? update : null,
    );

  }
}