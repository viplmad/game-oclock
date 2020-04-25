import 'package:flutter/material.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/bar_item.dart';
import 'detail/detail.dart';


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
  color: gameColour,
  views: gameViews,
);
const BarItem dlcBarItem = BarItem(
  title: dlcTable,
  icon: Icons.widgets,
  color: dlcColour,
  views: dlcViews,
);
const BarItem purchaseBarItem = BarItem(
  title: purchaseTable,
  icon: Icons.local_grocery_store,
  color: purchaseColour,
  views: purchaseViews,
);
const BarItem storeBarItem = BarItem(
  title: storeTable,
  icon: Icons.store,
  color: storeColour,
  views: storeViews,
);
const BarItem platformBarItem = BarItem(
  title: platformTable,
  icon: Icons.phonelink,
  color: platformColour,
  views: platformViews,
);