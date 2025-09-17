import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/models/models.dart' show GameAvailable;

class GameAvailableTileListItem extends StatelessWidget {
  const GameAvailableTileListItem({super.key, required this.data, this.onTap});

  final GameAvailable data;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(title: data.name);
  }
}
