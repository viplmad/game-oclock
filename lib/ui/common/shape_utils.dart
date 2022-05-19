import 'package:flutter/material.dart';

class ShapeUtils {
  ShapeUtils._();

  // TODO Temporal fix for material 3 chip shape
  static const OutlinedBorder chipShapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  );

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

  static const BorderRadius cardBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(12.0),
    topRight: Radius.circular(12.0),
    bottomLeft: Radius.circular(12.0),
    bottomRight: Radius.circular(12.0),
  );
}
