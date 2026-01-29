import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart'
    show GridListItem, TileListItem;
import 'package:game_oclock/models/models.dart' show Location;

class LocationTileListItem extends StatelessWidget {
  const LocationTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final Location data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.name,
      imageURL: data.imageUrl,
      onTap: onTap,
    );
  }
}

class LocationGridListItem extends StatelessWidget {
  const LocationGridListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final Location data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return GridListItem(
      title: data.name,
      imageURL: data.imageUrl,
      onTap: onTap,
    );
  }
}
