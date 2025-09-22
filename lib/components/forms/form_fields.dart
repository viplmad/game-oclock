import 'package:flutter/material.dart';
import 'package:game_oclock/constants/form_validators.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show DropdownField;
import 'package:game_oclock/utils/localisation_extension.dart';

class SimpleTextFormField extends StatelessWidget {
  const SimpleTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    this.validator,
    this.maxLines = 1,
    this.obscureText = false,
    //
    this.suffixIcon,
    this.focusNode,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final int maxLines;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        label: FormFieldLabel(text: label, required: required),
        suffixIcon: suffixIcon,
      ),
      validator:
          validator ??
          (required
              ? (final value) => notEmptyValidator(context, value)
              : null),
      maxLines: maxLines,
      obscureText: obscureText,
      //
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

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
      errorText: 'malo malo',
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

class SimpleObscuredTextFormField extends StatefulWidget {
  const SimpleObscuredTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final FormFieldValidator<String>? validator;

  @override
  State<SimpleObscuredTextFormField> createState() =>
      _SimpleObscuredTextFormFieldState();
}

class _SimpleObscuredTextFormFieldState
    extends State<SimpleObscuredTextFormField> {
  bool obscureText = true;

  @override
  Widget build(final BuildContext context) {
    return SimpleTextFormField(
      controller: widget.controller,
      label: widget.label,
      required: widget.required,
      readOnly: widget.readOnly,
      validator: widget.validator,
      suffixIcon: IconButton(
        tooltip: obscureText
            ? context.localize().showLabel
            : context.localize().hideLabel,
        icon: Icon(obscureText ? CommonIcons.show : CommonIcons.hide),
        onPressed: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
      ),
      obscureText: obscureText,
      maxLines: 1,
    );
  }
}

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({super.key, required this.text, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(final BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        children: required
            ? <InlineSpan>[
                const TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red), // TODO theme
                ),
              ]
            : null,
      ),
    );
  }
}
