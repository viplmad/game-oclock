import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show OptionTextField;
import 'package:game_oclock/utils/form_validators.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'common.dart';
import 'text.dart';

class SimpleSelectFormField extends StatelessWidget {
  const SimpleSelectFormField({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
    required this.options,
  });

  final FormControl<String> formControl;
  final bool readOnly;
  final String label;
  final List<OptionTextField<String>> options;

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder(
      formControl: formControl,
      builder: (context, _, _) => DropdownMenuFormField<String>(
        enabled: !readOnly,
        initialSelection: formControl.value,
        enableFilter: true,
        requestFocusOnTap: true,
        label: FormFieldLabel(
          text: label,
          required: formControl.validators.any(
            (validator) => validator is NotEmptyValidator,
          ),
        ),
        trailingIcon: readOnly || formControl.isNotNullOrEmpty
            ? null
            : ClearIconButton(onTap: () => formControl.value = null),
        forceErrorText: formControl.hasErrors
            ? formControl.errors.values.first as String
            : null,
        /*validator: (final value) {
          return formControl.validators
              .fold(<String, dynamic>{}, (final prev, final validator) {
                final val = validator.validate(formControl);
                return val == null ? prev : prev
                  ..addAll(val!);
              })
              .entries
              .where((final e) => e.value is bool && e.value as bool)
              .map((final e) => e.key)
              .firstOrNull;
        },*/
        dropdownMenuEntries: options
            .map(
              (field) => DropdownMenuEntry<String>(
                value: field.value,
                label: field.labelBuilder(context),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class SimpleMultipleSelectFormField extends StatefulWidget {
  const SimpleMultipleSelectFormField({
    super.key,
    required this.formArray,
    required this.label,
    this.required = false,
    this.readOnly = false,
  });

  final FormArray<String> formArray;
  final bool required;
  final bool readOnly;
  final String label;

  @override
  State<SimpleMultipleSelectFormField> createState() =>
      _SimpleMultipleSelectFormFieldState();
}

class _SimpleMultipleSelectFormFieldState
    extends State<SimpleMultipleSelectFormField> {
  late final FormControl<String> textFormControl;
  late final StreamSubscription<String?> textListener;
  final separator = ',';

  @override
  void initState() {
    textFormControl = FormControl<String>(
      value: _buildTextValue(widget.formArray.value),
      validators: widget.formArray.validators,
    );
    textFormControl.setErrors(widget.formArray.errors, markAsDirty: false);
    textListener = textFormControl.valueChanges.listen((value) {
      widget.formArray.value = value
          ?.split(separator)
          .map((e) => e.trim())
          .toList(growable: false);
    });

    super.initState();
  }

  @override
  void dispose() {
    unawaited(textListener.cancel());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTextFormField(
      formControl: textFormControl,
      readOnly: widget.readOnly,
      label: widget.label,
      onCleared: () {
        widget.formArray.value = null;
        textFormControl.setErrors(widget.formArray.errors);
      },
    );
  }

  String? _buildTextValue(List<String?>? value) {
    return value?.join('$separator ');
  }
}
