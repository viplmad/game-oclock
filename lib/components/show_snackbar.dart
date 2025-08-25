import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier;
import 'package:game_oclock/utils/layout_tier_utils.dart';

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
