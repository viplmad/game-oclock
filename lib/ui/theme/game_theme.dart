import 'package:flutter/material.dart';

import 'package:game_collection/model/bar_data.dart';
import 'package:game_collection/entity/entity.dart';


const Color gameColour = Colors.red;
const Color gameAccentColour = Colors.redAccent;

const List<Color> statusColours = [
  Colors.grey,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.greenAccent,
];

const List<String> gameViews = [
  "Main",
  "Last Created",
  "Playing",
  "Next Up",
  "Last Finished",
  "2019 in Review",
];

const BarData gameBarData = BarData(
  title: gameTable,
  icon: Icons.videogame_asset,
  color: gameColour,
  views: gameViews,
);


const BarData allTabData = BarData(
  title: "All",
  icon: Icons.done_all,
  views: gameViews,
);

const BarData gameTabData = BarData(
  title: "Games",
  icon: Icons.videogame_asset,
  views: gameViews,
);

const BarData romTabData = BarData(
  title: "Roms",
  icon: Icons.file_download,
  views: gameViews,
);