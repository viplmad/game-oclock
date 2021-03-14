import 'package:flutter/material.dart';


void showSnackBar({required ScaffoldState scaffoldState, required String message, int seconds = 3, SnackBarAction? snackBarAction}) {

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(message),
    duration: Duration(seconds: seconds),
    action: snackBarAction,
    padding: const EdgeInsets.only(left: 16.0, right: 8.0),
  );

  scaffoldState.hideCurrentSnackBar();
  scaffoldState.showSnackBar(snackBar);

}

SnackBarAction dialogSnackBarAction(BuildContext context, {required String label, required String title, required String content}) {

  return SnackBarAction(
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
              FlatButton(
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