import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class ShowHideTextFormField extends StatefulWidget {
  const ShowHideTextFormField({
    super.key,
    this.controller,
    this.readOnly = false,
    this.validator,
    this.labelText,
  });

  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final String? labelText;

  @override
  State<ShowHideTextFormField> createState() => _ShowHideTextFormFieldState();
}

class _ShowHideTextFormFieldState extends State<ShowHideTextFormField> {
  bool obscureText = true;

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      maxLines: 1,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: widget.labelText,
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
      ),
      //keyboardType: widget.keyboardType,
      //inputFormatters: widget.inputFormatters,
      validator: widget.validator,
    );
  }
}
