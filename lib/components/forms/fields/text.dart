import 'package:flutter/material.dart';
import 'package:game_oclock/constants/form_validators.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'label.dart';

class SimpleTextFormField extends StatelessWidget {
  SimpleTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    this.validator,
    this.hint,
    this.maxLines = 1,
    this.obscureText = false,
    //
    final List<Widget>? suffixIcons,
    this.focusNode,
    this.onFieldSubmitted,
  }) : suffixIcons =
           suffixIcons ??
           [
             ClearIconButton(
               readOnly: readOnly,
               onTap: () => controller.clear(),
             ),
           ];

  final TextEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final String? hint;
  final bool obscureText;
  final int maxLines;
  final List<Widget> suffixIcons;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        label: FormFieldLabel(text: label, required: required),
        hintText: hint,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: suffixIcons,
        ),
        border: const OutlineInputBorder(),
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
      suffixIcons: [
        ClearIconButton(
          readOnly: widget.readOnly,
          onTap: () => widget.controller.clear(),
        ),
        IconButton(
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
      ],
      obscureText: obscureText,
      maxLines: 1,
    );
  }
}
