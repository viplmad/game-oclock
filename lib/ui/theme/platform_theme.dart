import 'package:flutter/material.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/bar_data.dart';


const Color platformColour = Colors.black87;
const Color platformAccentColour = Colors.black12;

const List<Color> typeColours = [
  Colors.blueAccent,
  Colors.deepPurpleAccent,
];
const List<String> platformViews = [
  "Main",
  "Last Created",
];

const BarData platformBarData = BarData(
  title: platformTable,
  icon: Icons.phonelink,
  color: platformColour,
  views: platformViews,
);