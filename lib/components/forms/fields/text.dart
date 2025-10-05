import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'common.dart';

class SimpleTextFormField extends StatefulWidget {
  const SimpleTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    this.validator,
    this.hint,
    this.multiline = false,
    this.obscureText = false,
    //
    this.suffixIcons,
    this.onClear,
    this.focusNode,
    this.onFieldSubmitted,
    this.onTap,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final String? hint;
  final bool obscureText;
  final bool multiline;
  final List<Widget>? suffixIcons;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;

  @override
  State<SimpleTextFormField> createState() => _SimpleTextFormFieldState();
}

class _SimpleTextFormFieldState extends State<SimpleTextFormField> {
  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      controller: widget.controller,
      decoration: InputDecoration(
        label: FormFieldLabel(text: widget.label, required: widget.required),
        hintText: widget.hint,
        suffixIcon: widget.readOnly
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.controller.text.isNotEmpty)
                    ClearIconButton(
                      onTap: () {
                        widget.controller.clear();
                        widget.onClear?.call();
                        setState(() {});
                      },
                    ),
                  ...?widget.suffixIcons,
                ],
              ),
        border: const OutlineInputBorder(),
      ),
      validator:
          widget.validator ??
          (widget.required
              ? (final value) => notEmptyValidator(context, value)
              : null),
      maxLines: widget.multiline ? null : 1,
      keyboardType: widget.multiline
          ? TextInputType.multiline
          : TextInputType.text,
      obscureText: widget.obscureText,
      onChanged: (_) => setState(() {}),
      onTap: widget.onTap,
      //
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
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
    );
  }
}
