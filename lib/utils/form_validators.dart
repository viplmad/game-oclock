import 'package:flutter/material.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/string_utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Validator that requires the control have a non-empty value.
class NotEmptyValidator extends Validator<dynamic> {
  const NotEmptyValidator(this.context) : super();

  final BuildContext context;

  @override
  Map<String, dynamic>? validate(final AbstractControl<dynamic> control) {
    final error = <String, dynamic>{
      context.localize().notEmptyValidationError: true,
    };

    if (control.value == null) {
      return error;
    } else if (control.value is String) {
      return isStringEmpty(control.value) ? error : null;
    }

    return null;
  }
}
