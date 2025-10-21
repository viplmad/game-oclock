import 'package:flutter/material.dart';
import 'package:game_oclock/constants/constants.dart';

Widget forceCardRound(final Widget widget) {
  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
    child: widget,
  );
}

Widget forceRectangular(final Widget widget) {
  return ClipRRect(borderRadius: BorderRadius.zero, child: widget);
}
