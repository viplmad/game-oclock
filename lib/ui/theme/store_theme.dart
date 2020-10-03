import 'package:flutter/material.dart';

import 'package:game_collection/model/bar_data.dart';
import 'package:game_collection/entity/entity.dart';


const Color storeColour = Colors.blueGrey;
const Color storeAccentColour = Colors.grey;

const List<String> storeViews = [
  "Main",
  "Last Created",
];

const BarData storeBarData = BarData(
  title: storeTable,
  icon: Icons.store,
  color: storeColour,
  views: storeViews,
);