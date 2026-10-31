import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart' show ErrorDTO, LayoutTier;
import 'package:game_oclock/pages/routes.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:go_router/go_router.dart';

import 'copy_to_clipboard.dart';

void goBack(BuildContext context, {String? defaultPath}) {
  final PathHistory history = RepositoryProvider.of(context);
  final historyPath = history.pop();

  final path = historyPath ?? defaultPath;
  if (path == null) {
    GoRouter.of(context).pop();
  } else {
    GoRouter.of(context).go(path);
  }
}

void go(BuildContext context, {required String path}) {
  GoRouter.of(context).go(path);
}

void showSnackBar(
  BuildContext context, {
  required String message,
  int seconds = 4, // Recommended 4-10 seconds
  SnackBarAction? snackBarAction,
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
  BuildContext context, {
  required String name,
  required ErrorDTO error,
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
  BuildContext context, {
  required String label,
  required String title,
  required String content,
}) {
  return backgroundSnackBarAction(
    context,
    label: label,
    onPressed: () async => await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
  BuildContext context, {
  required String label,
  required void Function() onPressed,
}) {
  return SnackBarAction(label: label, onPressed: onPressed);
}
