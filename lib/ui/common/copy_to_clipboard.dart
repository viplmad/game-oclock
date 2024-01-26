import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:game_oclock/ui/common/show_snackbar.dart';

void copyToClipboardAndNotify(
  BuildContext context,
  String text,
  String notificationMessage,
) async {
  Clipboard.setData(
    ClipboardData(text: text),
  ).then(
    (_) => showSnackBar(
      context,
      message: notificationMessage,
    ),
  );
}
