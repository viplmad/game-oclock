import 'package:flutter/material.dart';

class FABUtils {
  FABUtils._();

  static Color? backgroundIfActive({required bool enabled}) {
    return enabled ? null : Colors.grey;
  }
}
