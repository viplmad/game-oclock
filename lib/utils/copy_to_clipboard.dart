import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'show_snackbar.dart';

Future<void> copyToClipboardAndNotify(
  final BuildContext context, {
  required final String text,
  required final String notificationMessage,
}) {
  return Clipboard.setData(ClipboardData(text: text)).then((_) {
    if (context.mounted) {
      showSnackBar(context, message: notificationMessage);
    }
  });
}
