import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/models/models.dart'
    show LocationWithDate, UserGameWithDate;
import 'package:game_oclock/utils/localisation_extension.dart';

class LocationWithDateTileListItem extends StatelessWidget {
  const LocationWithDateTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final LocationWithDate data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.name,
      subtitle: MaterialLocalizations.of(context).formatCompactDate(data.date),
      imageURL: data.imageUrl,
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

  final UserGameWithDate data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.edition.isEmpty
          ? data.title
          : context.localize().gameEditionDataTitle(data.title, data.edition),
      subtitle: MaterialLocalizations.of(context).formatCompactDate(data.date),
      imageURL: data.imageUrl,
      onTap: onTap,
    );
  }
}
