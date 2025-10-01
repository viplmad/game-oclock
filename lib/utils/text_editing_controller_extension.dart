import 'package:flutter/material.dart';

extension TextEditingControllerExtension on TextEditingController {
  void setValue(final String? newValue) {
    value = value.copyWith(text: newValue);
  }
}
