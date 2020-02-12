import 'package:flutter/material.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/bar_item.dart';
import 'package:game_collection/model/model.dart';


const List<BarItem> barItems = [
  gameBarItem,
  dlcBarItem,
  purchaseBarItem,
  storeBarItem,
  platformBarItem,
];

const BarItem gameBarItem = BarItem(
  title: gameTable,
  icon: Icons.videogame_asset,
  color: Colors.redAccent,
  views: GameViews,
);
const BarItem dlcBarItem = BarItem(
  title: dlcTable,
  icon: Icons.widgets,
  color: Colors.deepPurpleAccent,
  views: [],
);
const BarItem purchaseBarItem = BarItem(
  title: purchaseTable,
  icon: Icons.local_grocery_store,
  color: Colors.lightBlueAccent,
  views: [],
);
const BarItem storeBarItem = BarItem(
  title: storeTable,
  icon: Icons.store,
  color: Colors.grey,
  views: [],
);
const BarItem platformBarItem = BarItem(
  title: platformTable,
  icon: Icons.phonelink,
  color: Colors.black87,
  views: [],
);