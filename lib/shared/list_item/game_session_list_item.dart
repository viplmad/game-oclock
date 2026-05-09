import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock_client/api.dart';

class GameSessionTileListItem extends StatelessWidget {
  const GameSessionTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final SessionDTO data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.startDatetime.toIso8601String(),
      onTap: onTap,
    );
  }
}
