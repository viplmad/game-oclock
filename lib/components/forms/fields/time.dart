import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

import 'text.dart';

class SimpleTimeFormField extends StatefulWidget {
  const SimpleTimeFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
  });

  final TimeEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;

  @override
  State<SimpleTimeFormField> createState() => _SimpleTimeFormFieldState();
}

class _SimpleTimeFormFieldState extends State<SimpleTimeFormField> {
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
          tooltip: context.localize().showTimePicker,
          icon: CommonIcons.timePicker,
          onPressed: widget.readOnly ? null : () async => _showPicker(),
        ),
      ],
      onTap: widget.readOnly ? null : () async => _showPicker(),
    );
  }

  Future<void> _showPicker() {
    return showTimePicker(
      context: context,
      initialTime: widget.controller.value ?? TimeOfDay.now(),
      builder: (final BuildContext context, final Widget? child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    ).then<void>((final value) {
      if (value != null) {
        widget.controller.setValue(value);
        textController.setValue(_buildTextValue(value));

        setState(() {});
      }
    });
  }

  String? _buildTextValue(final TimeOfDay? value) {
    if (value == null) {
      return null;
    }

    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    return localizations.formatTimeOfDay(value, alwaysUse24HourFormat: true);
  }
}

class TimeEditingController extends ValueNotifier<TimeOfDay?> {
  TimeEditingController({final TimeOfDay? time}) : super(time);

  void clear() {
    value = null;
  }

  void setValue(final TimeOfDay? newValue) {
    value = newValue;
  }
}
