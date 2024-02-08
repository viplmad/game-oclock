import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

import 'package:game_oclock/ui/theme/theme.dart' show AppTheme;
import 'package:game_oclock/ui/common/copy_to_clipboard.dart';
import 'package:game_oclock/ui/common/header_text.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../route_constants.dart';

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

void showApiErrorSnackbar(
  BuildContext context, {
  required String name,
  required ErrorCode error,
  required String errorDescription,
}) async {
  bool showMore = true;

  if (error == ErrorCode.authInvalidGrant ||
      error == ErrorCode.authInvalidRequest ||
      error == ErrorCode.authUnsupportedGrantType ||
      error == ErrorCode.unauthorized) {
    // When unauthorized -> navigate to server settings page
    // Remove previous routes so we can't go to a homepage of old login
    Navigator.pushNamedAndRemoveUntil(
      context,
      serverSettingsRoute,
      // Remove all the routes
      (_) => false,
    );
    // Avoid showing more if context moved
    showMore = false;
  }

  final String message = AppLocalizationsUtils.getErrorMessage(context, error);
  final String title = '$name - $message';
  showSnackBar(
    context,
    message: title,
    snackBarAction: showMore
        ? _apiErrorSnackBarAction(
            context,
            label: MaterialLocalizations.of(context).moreButtonTooltip,
            title: title,
            content: errorDescription,
          )
        : null,
  );
}

SnackBarAction _apiErrorSnackBarAction(
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
            title: HeaderText(title),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: <Widget>[
                  Text(content),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(MaterialLocalizations.of(context).copyButtonLabel),
                onPressed: () {
                  copyToClipboardAndNotify(
                    context,
                    '$title\n\n$content',
                    AppLocalizations.of(context)!.errorCopiedString,
                  );
                },
              ),
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
