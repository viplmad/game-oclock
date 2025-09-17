import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/models/models.dart' show ExternalGame;

class ExternalGameTileListItem extends StatelessWidget {
  const ExternalGameTileListItem({super.key, required this.data, this.onTap});

  final ExternalGame data;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.title,
      subtitle: data.releaseDate?.toIso8601String(),
      imageURL: data.coverUrl,
      trailing: const Icon(Icons.cloud), // TODO icon of external source
      onTap: onTap,
    );
  }
}
