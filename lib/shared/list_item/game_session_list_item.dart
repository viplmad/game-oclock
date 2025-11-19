import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/models/models.dart' show GameSession;

class GameSessionTileListItem extends StatelessWidget {
  const GameSessionTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final GameSession data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(title: data.start.toIso8601String(), onTap: onTap);
  }
}
