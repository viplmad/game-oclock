import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'common.dart';

class SimpleTextFormField extends StatelessWidget {
  const SimpleTextFormField({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
    this.hint,
    this.multiline = false,
    this.obscureText = false,
    //
    this.prefixIcon,
    this.suffixIcons,
    this.onCleared,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
  });

  final FormControl<String> formControl;
  final String label;
  final bool readOnly;
  final String? hint;
  final bool obscureText;
  final bool multiline;
  final Widget? prefixIcon;
  final List<Widget>? suffixIcons;
  final VoidCallback? onCleared;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return ReactiveTextField(
      formControl: formControl,
      readOnly: readOnly,
      decoration: InputDecoration(
        label: FormFieldLabel(
          text: label,
          required: formControl.validators.any(
            (final validator) => validator is NotEmptyValidator,
          ),
        ),
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: readOnly
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ReactiveValueListenableBuilder(
                    formControl: formControl,
                    builder: (_, _, _) {
                      if (formControl.isNotNullOrEmpty) {
                        return ClearIconButton(
                          onTap: () {
                            formControl.value = null;
                            onCleared?.call();
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  ...?suffixIcons,
                ],
              ),
        border: const OutlineInputBorder(),
      ),
      maxLines: multiline ? null : 1,
      keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
      obscureText: obscureText,
      onTap: (_) => onTap?.call(),
      onChanged: onChanged != null
          ? (_) => onChanged!(formControl.value ?? '')
          : null,
      //
      focusNode: focusNode,
      onSubmitted: onFieldSubmitted != null
          ? (_) => onFieldSubmitted!(formControl.value ?? '')
          : null,
    );
  }
}

class SimpleObscuredTextFormField extends StatefulWidget {
  const SimpleObscuredTextFormField({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
  });

  final FormControl<String> formControl;
  final String label;
  final bool readOnly;

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
      formControl: widget.formControl,
      label: widget.label,
      readOnly: widget.readOnly,
      suffixIcons: [
        IconButton(
          tooltip: obscureText
              ? context.localize().showLabel
              : context.localize().hideLabel,
          icon: obscureText ? CommonIcons.show : CommonIcons.hide,
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
