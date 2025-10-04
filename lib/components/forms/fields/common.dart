import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

const requiredSuffix = TextSpan(text: '*');

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({super.key, required this.text, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(final BuildContext context) {
    return Text.rich(
      TextSpan(text: text, children: required ? [requiredSuffix] : null),
    );
  }
}

class ClearIconButton extends StatelessWidget {
  const ClearIconButton({
    super.key,
    required this.readOnly,
    required this.onTap,
  });

  final bool readOnly;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return IconButton(
      tooltip: context.localize().clearLabel,
      icon: const Icon(CommonIcons.clear),
      onPressed: readOnly ? null : onTap,
    );
  }
}
