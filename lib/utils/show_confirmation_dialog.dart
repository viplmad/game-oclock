import 'package:flutter/material.dart';

import 'show_form_dialog.dart';

Future<void> showConfirmationDialog(
  final BuildContext context, {
  required final ConfirmationDialog Function(BuildContext context) builder,
  required final ValueChanged<BuildContext> onSuccess,
  final ValueChanged<BuildContext>? onFailure,
}) async {
  return showReturningDialog<bool>(
    context,
    builder: builder,
    onSuccess: (final context, final data) {
      if (data) {
        onSuccess(context);
      }
    },
    onFailure: onFailure,
  );
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.acceptLabel,
  });

  final String title;
  final String subtitle;
  final String message;
  final String acceptLabel;

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: ListTile(title: Text(message), subtitle: Text(subtitle)),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () async => await Navigator.maybePop(context),
        ),
        TextButton(
          onPressed: () async => await Navigator.maybePop(context, true),
          child: Text(acceptLabel),
        ),
      ],
    );
  }
}

class YearPickerDialog extends StatefulWidget {
  const YearPickerDialog({super.key, this.year});

  final int? year;

  @override
  State<YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<YearPickerDialog> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.year != null
        ? DateTime(widget.year!)
        : DateTime.now();
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              color: Theme.of(context).primaryColor,
              //borderRadius: ShapeUtils.dialogBorderRadius,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    MaterialLocalizations.of(context).formatYear(_selectedDate),
                    style: Theme.of(context).primaryTextTheme.titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: YearPicker(
              firstDate: DateTime(1970),
              lastDate: DateTime.now(),
              selectedDate: _selectedDate,
              onChanged: (final newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              },
            ),
          ),
          OverflowBar(
            children: <Widget>[
              TextButton(
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
                ),
                onPressed: () async => await Navigator.maybePop<int>(context),
              ),
              TextButton(
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
                onPressed: () async =>
                    await Navigator.maybePop<int>(context, _selectedDate.year),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
