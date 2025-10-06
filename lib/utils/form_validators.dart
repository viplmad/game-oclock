import 'package:flutter/material.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'string_utils.dart';

String? notEmptyValidator(final BuildContext context, final String? value) {
  if (isStringEmpty(value)) {
    return context.localize().notEmptyValidationError;
  }
  return null;
}

String? notEqualValidator(
  final BuildContext context,
  final String? value,
  final String? other,
) {
  if (value != other) {
    return context.localize().notEqualValidationError;
  }
  return null;
}

String? someIsBlankValidator(
  final BuildContext context,
  final String? value,
  final String separator,
) {
  final List<String> values = value?.split(separator) ?? [];
  if (!isStringBlank(value) && values.any(isStringBlank)) {
    return context.localize().someIsBlankValidationError;
  }
  return null;
}
