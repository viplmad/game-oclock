import 'package:flutter/material.dart';

import 'common.dart';

class SimpleBoolFormField extends StatefulWidget {
  const SimpleBoolFormField({
    super.key,
    required this.controller,
    required this.label,
    this.readOnly = false,
  });

  final BoolEditingController controller;
  final String label;
  final bool readOnly;

  @override
  State<SimpleBoolFormField> createState() => _SimpleBoolFormFieldState();
}

class _SimpleBoolFormFieldState extends State<SimpleBoolFormField> {
  @override
  Widget build(final BuildContext context) {
    return SwitchListTile(
      value: widget.controller.value ?? false,
      onChanged: widget.readOnly
          ? null
          : (final value) {
              widget.controller.setValue(value);
              setState(() {});
            },
      title: FormFieldLabel(text: widget.label),
    );
  }
}

class BoolEditingController extends ValueNotifier<bool?> {
  BoolEditingController({final bool? value}) : super(value);

  void clear() {
    value = null;
  }

  // ignore: avoid_positional_boolean_parameters
  void setValue(final bool? newValue) {
    value = newValue;
  }
}
