import 'package:flutter/material.dart';

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

SnackBarAction dialogSnackBarAction(
  BuildContext context, {
  required String label,
  required String title,
  required String content,
}) {
  return backgroundSnackBarAction(
    context,
    label: label,
    onPressed: () {
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
    textColor: Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black,
    onPressed: onPressed,
  );
}
