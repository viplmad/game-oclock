import 'package:flutter/material.dart';

Future<DateTime?> showGameDatePicker({
  required BuildContext context,
  DateTime? initialDate,
}) async {
  return showDatePicker(
    context: context,
    firstDate: DateTime(1970),
    lastDate: DateTime.now(),
    initialDate: initialDate ?? DateTime.now(),
  );
}
