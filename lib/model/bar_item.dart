import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';

import 'package:equatable/equatable.dart';


class BarItem extends Equatable {

  final String title;
  final IconData icon;
  final Color color;

  const BarItem({@required this.title, this.color, @required this.icon});

  @override
  List<Object> get props => [title, icon, color];

  @override
  String toString() {

    return 'DLC { '
        'title: $title, '
        'icon: $icon, '
        'color: $color'
        ' }';

  }

}