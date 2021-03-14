import 'package:flutter/material.dart';

import 'package:numberpicker/numberpicker.dart';


class DurationPickerDialog extends StatefulWidget {
  const DurationPickerDialog({
    Key? key,
    required this.fieldName,
    required this.initialDuration,
  }) : super(key: key);

  final String fieldName;
  final Duration initialDuration;

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}
class _DurationPickerDialogState extends State<DurationPickerDialog> {
  int _hours = 0;
  int _minutes = 0;

  @override
  void initState() {
    super.initState();

    _hours = widget.initialDuration.inHours;
    _minutes = widget.initialDuration.inMinutes - (_hours * 60);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.fieldName),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NumberPicker(
              value: _hours,
              minValue: 0,
              maxValue: 1000,
              //TODO highlightSelectedValue: true,
              onChanged: (num newHours) {
                setState(() {
                  _hours = newHours.toInt();
                });
              }
          ),
          Text(':', style: Theme.of(context).textTheme.headline6,),
          NumberPicker(
              value: _minutes,
              minValue: 0,
              maxValue: 59,
              //TODO highlightSelectedValue: true,
              onChanged: (num newMin) {
                setState(() {
                  _minutes = newMin.toInt();
                });
              }
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop<Duration>(context);
          },
        ),
        FlatButton(
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            Navigator.maybePop<Duration>(context, Duration(hours: _hours, minutes: _minutes));
          },
        ),
      ],
    );
  }
}