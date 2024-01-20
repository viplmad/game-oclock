import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

import 'package:game_oclock/ui/theme/theme.dart' show AppTheme;
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
  int seconds = 3,
  SnackBarAction? snackBarAction,
}) {
  final SnackBar snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(message),
    duration: Duration(seconds: seconds),
    action: snackBarAction,
  );

  final ScaffoldMessengerState messengerState = ScaffoldMessenger.of(context);

  messengerState.hideCurrentSnackBar();
  messengerState.showSnackBar(snackBar);
}

void showErrorSnackbar(
  BuildContext context,
  ErrorCode error,
  String errorDescription,
) {
  final String message = AppLocalizationsUtils.getErrorMessage(context, error);
  showSnackBar(
    context,
    message: message,
    snackBarAction: _dialogSnackBarAction(
      context,
      label: AppLocalizations.of(context)!.moreString,
      title: message,
      content: errorDescription,
    ),
  );
}

SnackBarAction _dialogSnackBarAction(
  BuildContext context, {
  required String label,
  required String title,
  required String content,
}) {
  return backgroundSnackBarAction(
    context,
    label: label,
    onPressed: () async {
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(content),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
                onPressed: () {
                  Navigator.maybePop<bool>(context, true);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

SnackBarAction backgroundSnackBarAction(
  BuildContext context, {
  required String label,
  required void Function() onPressed,
}) {
  return SnackBarAction(
    label: label,
    textColor: AppTheme.defaultThemeTextColorReverse(context),
    onPressed: onPressed,
  );
}
