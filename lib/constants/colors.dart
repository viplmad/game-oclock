import 'package:flutter/material.dart';

class CommonColors {
  CommonColors._();

  static const white = Colors.white;
  static const black = Colors.black87;
  static const grey = Colors.grey;
  static Color darkerGrey = Colors.grey[800]!;
  static const transparent = Colors.transparent;
  static Color blackTransparent = Colors.black87.withAlpha(128);

  static const rating = Color(0xA0B71C1C);
  static const wishlist = Colors.yellow;
  static Color planning = Colors.red[200]!;
  static const inProgress = Colors.blue;
  static const completed = Colors.green;
  static const dropped = Colors.grey;
  static Color finished = Colors.grey[800]!;
  static const active = Colors.red;

  static const gold = Color(0xffC9B037);
  static Color silver = finished;
  static const bronze = Color(0xffAD8A56);

  static final List<Color> chartColors = <Color>[
    Colors.redAccent,
    Colors.deepPurpleAccent,
    Colors.blueAccent,
    Colors.lightGreen[700]!,
    Colors.deepOrangeAccent,
    Colors.blueGrey,
    Colors.brown,
    Colors.lime[900]!,
    Colors.indigoAccent,
    Colors.pinkAccent,
    Colors.cyan[700]!,
    Colors.purple[300]!,
    Colors.orangeAccent,
  ];
}
