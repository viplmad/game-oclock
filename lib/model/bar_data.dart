import 'package:meta/meta.dart';

import 'package:flutter/material.dart';


class BarData {

  const BarData({
    @required this.title,
    this.color,
    @required this.icon,
  });

  final String title;
  final IconData icon;
  final Color color;

}