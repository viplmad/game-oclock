import 'package:flutter/material.dart';

import 'package:numberpicker/numberpicker.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'generic_field.dart';

class DoubleField extends StatelessWidget {
  const DoubleField({
    Key? key,
    required this.fieldName,
    required this.value,
    required this.shownValue,
    this.editable = true,
    this.update,
  }) : super(key: key);

  final String fieldName;
  final double? value;
  final String? shownValue;
  final bool editable;
  final void Function(double)? update;

  @override
  Widget build(BuildContext context) {
    return GenericField<double>(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue,
      editable: editable,
      update: update,
      onTap: () {
        return showDialog<double>(
          context: context,
          builder: (BuildContext context) {
            return _DecimalPickerDialog(
              fieldName: fieldName,
              number: value ?? 0,
            );
          },
        );
      },
    );
  }
}

class _DecimalPickerDialog extends StatefulWidget {
  const _DecimalPickerDialog({
    Key? key,
    required this.fieldName,
    required this.number,
  }) : super(key: key);

  final String fieldName;
  final double number;

  @override
  State<_DecimalPickerDialog> createState() => _DecimalPickerDialogState();
}

class _DecimalPickerDialogState extends State<_DecimalPickerDialog> {
  int _integerPart = 0;
  int _decimalPart = 0;

  @override
  void initState() {
    super.initState();

    _integerPart = widget.number.truncate();
    _decimalPart = ((widget.number - _integerPart) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        GameCollectionLocalisations.of(context).editString(widget.fieldName),
      ),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NumberPicker(
            value: _integerPart,
            minValue: 0,
            maxValue: 1000,
            onChanged: (num newInteger) {
              setState(() {
                _integerPart = newInteger.toInt();
              });
            },
          ),
          Text(
            '.',
            style: Theme.of(context).textTheme.headline6,
          ),
          NumberPicker(
            value: _decimalPart,
            minValue: 0,
            maxValue: 99,
            infiniteLoop: true,
            onChanged: (num newDecimal) {
              setState(() {
                _decimalPart = newDecimal.toInt();
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop<double>(context);
          },
        ),
        TextButton(
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            Navigator.maybePop<double>(
              context,
              double.tryParse(
                '$_integerPart.${_decimalPart.toString().padLeft(2, '0')}',
              ),
            );
          },
        ),
      ],
    );
  }
}
