import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/models/models.dart' show Playthrough;

class PlaythroughTileListItem extends StatelessWidget {
  const PlaythroughTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final Playthrough data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(title: data.name, onTap: onTap);
  }
}
