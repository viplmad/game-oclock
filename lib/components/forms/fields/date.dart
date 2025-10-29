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
  late final TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController(
      text: _buildTextValue(widget.controller.value),
    );

    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return SimpleTextFormField(
      controller: textController,
      label: widget.label,
      required: widget.required,
      readOnly: false,
      onCleared: () {
        widget.controller.clear();
      },
      suffixIcons: [
        IconButton(
          tooltip: context.localize().showDatePicker,
          icon: CommonIcons.datePicker,
          onPressed: widget.readOnly ? null : () async => _showPicker(),
        ),
      ],
      onTap: widget.readOnly ? null : () async => _showPicker(),
    );
  }

  Future<void> _showPicker() {
    return showDatePicker(
      context: context,
      initialDate: widget.controller.value ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    ).then<void>((final value) {
      if (value != null) {
        widget.controller.setValue(value);
        textController.setValue(_buildTextValue(value));

        setState(() {});
      }
    });
  }

  String? _buildTextValue(final DateTime? value) {
    if (value == null) {
      return null;
    }

    return MaterialLocalizations.of(context).formatCompactDate(value);
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
