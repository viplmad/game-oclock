import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show OptionTextField;
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
  Widget build(final BuildContext context) {
    return ReactiveValueListenableBuilder(
      formControl: formControl,
      builder: (final context, _, _) => DropdownMenuFormField<String>(
        enabled: !readOnly,
        initialSelection: formControl.value,
        enableFilter: true,
        requestFocusOnTap: true,
        label: FormFieldLabel(
          text: label,
          required: formControl.validators.contains(Validators.required),
        ),
        trailingIcon: readOnly || formControl.isNotNullOrEmpty
            ? null
            : ClearIconButton(onTap: () => formControl.value = null),
        forceErrorText: formControl.hasErrors
            ? formControl.errors.values.first
                  as String // TODO use validator
            : null,
        dropdownMenuEntries: options
            .map(
              (final field) => DropdownMenuEntry<String>(
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
  final separator = ',';

  @override
  void initState() {
    textFormControl = FormControl<String>(
      value: _buildTextValue(widget.formArray.value),
      validators: widget.formArray.validators,
    );
    textFormControl.setErrors(widget.formArray.errors, markAsDirty: false);

    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    textFormControl.valueChanges.listen((final value) {
      widget.formArray.value = value
          ?.split(separator)
          .map((final e) => e.trim())
          .toList(growable: false);
    }); // TODO close

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

  String? _buildTextValue(final List<String?>? value) {
    return value?.join('$separator ');
  }
}
