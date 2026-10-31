import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

class LocationWithDateTileListItem extends StatelessWidget {
  const LocationWithDateTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final LocationAvailableDTO data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TileListItem(
      title: data.location.name,
      subtitle: MaterialLocalizations.of(context)
          .formatCompactDate(data.available.datetime),
      imageURL: data.location.imageUrl,
      onTap: onTap,
    );
  }
}

class GameWithDateTileListItem extends StatelessWidget {
  const GameWithDateTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final MediaAvailableDTO data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TileListItem(
      title: data.media.media.edition.isEmpty
          ? data.media.media.title
          : context.localize().gameEditionDataTitle(
              data.media.media.title,
              data.media.media.edition,
            ),
      subtitle: MaterialLocalizations.of(context)
          .formatCompactDate(data.available.datetime),
      imageURL: data.media.media.imageUrl,
      onTap: onTap,
    );
  }
}
