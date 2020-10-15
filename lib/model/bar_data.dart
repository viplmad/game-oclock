import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';


class BarData extends Equatable {

  const BarData({
    @required this.title,
    this.color,
    @required this.icon,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  List<Object> get props => [title, icon, color];

  @override
  String toString() {

    return 'BarItem { '
        'title: $title, '
        'icon: $icon, '
        'color: $color'
        ' }';

  }

}