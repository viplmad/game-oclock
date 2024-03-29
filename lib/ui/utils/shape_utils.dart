import 'package:flutter/material.dart';

class ShapeUtils {
  ShapeUtils._();

  // TODO Temporal fix for material 3 speed dial fab shape
  static const ShapeBorder fabShapeBorder = RoundedRectangleBorder(
    borderRadius: fabBorderRadius,
  );

  // TODO Temporal fix for material 3 dialog border
  static const BorderRadius dialogBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(28.0),
    topRight: Radius.circular(28.0),
  );

  static const BorderRadius fabBorderRadius =
      BorderRadius.all(Radius.circular(16.0));

  static const BorderRadius cardBorderRadius =
      BorderRadius.all(Radius.circular(12.0));

  static Widget forceCardRound(Widget widget) {
    return ClipRRect(
      borderRadius: ShapeUtils.cardBorderRadius,
      child: widget,
    );
  }
}
