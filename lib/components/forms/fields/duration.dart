import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

import 'text.dart';

class SimpleDurationFormField extends StatefulWidget {
  const SimpleDurationFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
  });

  final DurationEditingController controller;
  final bool required;
  final bool readOnly;
  final String label;

  @override
  State<SimpleDurationFormField> createState() =>
      _SimpleDurationFormFieldState();
}

class _SimpleDurationFormFieldState extends State<SimpleDurationFormField> {
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
          tooltip: context.localize().showDurationPicker,
          icon: CommonIcons.durationPicker,
          onPressed: widget.readOnly ? null : () async => _showPicker(),
        ),
      ],
      onTap: widget.readOnly ? null : () async => _showPicker(),
    );
  }

  Future<void> _showPicker() {
    return showDurationPicker(
      context: context,
      initialTime: widget.controller.value ?? Duration.zero,
    ).then<void>((final value) {
      if (value != null) {
        widget.controller.setValue(value);
        textController.setValue(_buildTextValue(value));

        setState(() {});
      }
    });
  }

  String? _buildTextValue(final Duration? value) {
    if (value == null) {
      return null;
    }

    return context.localize().duration(value);
  }
}

class DurationEditingController extends ValueNotifier<Duration?> {
  DurationEditingController({final Duration? duration}) : super(duration);

  void clear() {
    value = null;
  }

  void setValue(final Duration? newValue) {
    value = newValue;
  }
}
