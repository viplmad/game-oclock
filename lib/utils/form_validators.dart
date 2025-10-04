import 'package:flutter/material.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

String? notEmptyValidator(final BuildContext context, final String? value) {
  if (value == null || value.isEmpty) {
    return context.localize().notEmptyValidationError;
  }
  return null;
}
