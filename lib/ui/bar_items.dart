import 'package:flutter/material.dart';

import 'package:game_collection/model/bar_item.dart';

import 'package:game_collection/model/game.dart' as gameEntity;
import 'package:game_collection/model/dlc.dart' as dlcEntity;
import 'package:game_collection/model/purchase.dart' as purchaseEntity;
import 'package:game_collection/model/store.dart' as storeEntity;
import 'package:game_collection/model/platform.dart' as platformEntity;

const List<BarItem> barItems = [
  gameBarItem,
  dlcBarItem,
  purchaseBarItem,
  storeBarItem,
  platformBarItem,
];

const BarItem gameBarItem = BarItem(
  title: gameEntity.gameTable,
  icon: Icons.videogame_asset,
  color: Colors.redAccent,
);
const BarItem dlcBarItem = BarItem(
  title: dlcEntity.dlcTable,
  icon: Icons.widgets,
  color: Colors.deepPurpleAccent,
);
const BarItem purchaseBarItem = BarItem(
  title: purchaseEntity.purchaseTable,
  icon: Icons.local_grocery_store,
  color: Colors.lightBlueAccent,
);
const BarItem storeBarItem = BarItem(
  title: storeEntity.storeTable,
  icon: Icons.store,
  color: Colors.grey,
);
const BarItem platformBarItem = BarItem(
  title: platformEntity.platformTable,
  icon: Icons.phonelink,
  color: Colors.black87,
);