import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show ErrorDTO, LayoutTier;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'copy_to_clipboard.dart';

void showSnackBar(
  final BuildContext context, {
  required final String message,
  final int seconds = 4, // Recommended 4-10 seconds
  final SnackBarAction? snackBarAction,
}) {
  final mediaQuerySize = MediaQuery.sizeOf(context);
  final layoutTier = layoutTierFromSize(mediaQuerySize);

  EdgeInsetsGeometry? margin;
  if (layoutTier == LayoutTier.large || layoutTier == LayoutTier.extraLarge) {
    margin = EdgeInsets.only(
      bottom: 10.0,
      right:
          MediaQuery.of(context).size.width *
          (2.0 / 3.0), // Width of 1/3 of screen width
      left: 15.0,
      top: 5.0,
    );
  }

  final SnackBar snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(message),
    duration: Duration(seconds: seconds),
    action: snackBarAction,
    showCloseIcon: true,
    margin: margin,
  );

  final ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);

  messengerState.hideCurrentSnackBar();
  messengerState.showSnackBar(snackBar);
}

void showErrorSnackBar(
  final BuildContext context, {
  required final String name,
  required final ErrorDTO error,
}) async {
  final String title = context.localize().errorCodeNameDataTitle(
    error.code,
    name,
  );
  showSnackBar(
    context,
    message: title,
    snackBarAction: _errorSnackBarAction(
      context,
      label: MaterialLocalizations.of(context).moreButtonTooltip,
      title: title,
      content: error.message,
    ),
  );
}

SnackBarAction _errorSnackBarAction(
  final BuildContext context, {
  required final String label,
  required final String title,
  required final String content,
}) {
  return backgroundSnackBarAction(
    context,
    label: label,
    onPressed: () async => await showDialog<bool>(
      context: context,
      builder: (final BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () async => await copyToClipboardAndNotify(
              context,
              text: '$title\n\n$content',
              notificationMessage: context.localize().errorCopiedText,
            ),
            child: Text(MaterialLocalizations.of(context).copyButtonLabel),
          ),
          TextButton(
            onPressed: () async => await Navigator.maybePop(context, true),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    ),
  );
}

SnackBarAction backgroundSnackBarAction(
  final BuildContext context, {
  required final String label,
  required final void Function() onPressed,
}) {
  return SnackBarAction(label: label, onPressed: onPressed);
}
