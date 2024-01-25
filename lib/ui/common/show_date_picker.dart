import 'package:flutter/material.dart';

Future<DateTime?> showGameDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  return showDatePicker(
    context: context,
    firstDate: firstDate ?? DateTime(1970),
    lastDate: lastDate ?? DateTime.now(),
    initialDate: initialDate ?? DateTime.now(),
  );
}
