import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/bar_item.dart';


const List<BarItem> tabItems = [
  allTabItem,
  gameTabItem,
  romTabItem,
];

const BarItem allTabItem = BarItem(
  title: "All",
  icon: Icons.done_all,
  views: gameViews,
);
const BarItem gameTabItem = BarItem(
  title: "Games",
  icon: Icons.videogame_asset,
  views: gameViews,
);
const BarItem romTabItem = BarItem(
  title: "Roms",
  icon: Icons.file_download,
  views: gameViews,
);