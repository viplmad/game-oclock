import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DropdownField;
import 'package:game_oclock/utils/form_validators.dart';

import 'common.dart';
import 'text.dart';

class SimpleSelectFormField extends StatelessWidget {
  const SimpleSelectFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    required this.options,
  });

  final TextEditingController controller;
  final bool required;
  final bool readOnly;
  final String label;
  final List<DropdownField> options;

  @override
  Widget build(final BuildContext context) {
    return DropdownMenu<String>(
      enabled: !readOnly,
      controller: controller,
      enableFilter: true,
      requestFocusOnTap: true,
      label: FormFieldLabel(text: label, required: required),
      /*trailingIcon: readOnly || controller.text.isEmpty
          ? null
          : ClearIconButton(onTap: () => controller.clear()),*/
      // TODO required validator errorText: 'malo malo',
      dropdownMenuEntries: options
          .map(
            (final field) => DropdownMenuEntry<String>(
              value: field.value,
              label: field.labelBuilder(context),
            ),
          )
          .toList(growable: false),
    );
  }
}

class SimpleMultipleSelectFormField extends StatefulWidget {
  const SimpleMultipleSelectFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
  });

  final MultipleTextEditingController controller;
  final bool required;
  final bool readOnly;
  final String label;

  @override
  State<SimpleMultipleSelectFormField> createState() =>
      _SimpleMultipleSelectFormFieldState();
}

class _SimpleMultipleSelectFormFieldState
    extends State<SimpleMultipleSelectFormField> {
  late final TextEditingController textController;
  final separator = ',';

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
      required: widget.required,
      readOnly: widget.readOnly,
      label: widget.label,
      validator: (final value) =>
          someIsBlankValidator(context, value, separator),
      onChanged: (final value) => widget.controller.setValue(
        value
            .split(separator)
            .map((final e) => e.trim())
            .toList(growable: false),
      ),
      onCleared: () => widget.controller.clear(),
    );
  }

  String? _buildTextValue(final List<String>? value) {
    return widget.controller.value?.join('$separator ');
  }
}

class MultipleTextEditingController extends ValueNotifier<List<String>?> {
  MultipleTextEditingController({final List<String>? values}) : super(values);

  void clear() {
    value = null;
  }

  void setValue(final List<String>? newValues) {
    value = newValues;
  }
}
