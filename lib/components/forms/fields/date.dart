import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

import 'text.dart';

class SimpleDateFormField extends StatefulWidget {
  const SimpleDateFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTimeEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<SimpleDateFormField> createState() => _SimpleDateFormFieldState();
}

class _SimpleDateFormFieldState extends State<SimpleDateFormField> {
  final textController = TextEditingController();
  final calendarDelegate = const GregorianCalendarDelegate();

  @override
  Widget build(final BuildContext context) {
    return SimpleTextFormField(
      controller: textController,
      label: widget.label,
      required: widget.required,
      readOnly: false,
      onClear: () {
        widget.controller.clear();
      },
      suffixIcons: [
        IconButton(
          tooltip: context.localize().showDatePicker,
          icon: const Icon(CommonIcons.calendarPicker),
          onPressed: widget.readOnly ? null : () async => showPicker(),
        ),
      ],
      onTap: () async => showPicker(),
    );
  }

  Future<void> showPicker() {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );

    return showDatePicker(
      context: context,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      calendarDelegate: calendarDelegate,
    ).then<void>((final value) {
      if (value != null) {
        widget.controller.setValue(value);

        textController.setValue(
          calendarDelegate.formatCompactDate(value, localizations),
        );

        setState(() {});
      }
    });
  }
}

class DateTimeEditingController extends ValueNotifier<DateTime?> {
  DateTimeEditingController({final DateTime? date}) : super(date);

  void clear() {
    value = null;
  }

  void setValue(final DateTime? newValue) {
    value = newValue;
  }
}
