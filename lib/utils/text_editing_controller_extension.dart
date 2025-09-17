import 'package:flutter/material.dart';

extension TextEditingControllerExtension on TextEditingController {
  void setValue(final String? value) {
    this.value = this.value.copyWith(text: value);
  }
}
