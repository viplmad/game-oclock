import 'package:flutter/material.dart';

import 'package:game_collection/model/bar_data.dart';
import 'package:game_collection/entity/entity.dart';


const Color purchaseColour = Colors.lightBlue;
const Color purchaseAccentColour = Colors.lightBlueAccent;

const List<String> purchaseViews = [
  "Main",
  "Last Created",
  "Pending",
  "Last Purchased",
  "2019 in Review",
];

const BarData purchaseBarData = BarData(
  title: purchaseTable,
  icon: Icons.local_grocery_store,
  color: purchaseColour,
  views: purchaseViews,
);