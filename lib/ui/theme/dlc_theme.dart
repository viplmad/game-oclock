import 'package:flutter/material.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/bar_data.dart';


const Color dlcColour = Colors.deepPurple;
const Color dlcAccentColour = Colors.deepPurpleAccent;

const List<String> dlcViews = [
  "Main",
  "Last Created",
];

const BarData dlcBarData = BarData(
  title: dlcTable,
  icon: Icons.widgets,
  color: dlcColour,
  views: dlcViews,
);