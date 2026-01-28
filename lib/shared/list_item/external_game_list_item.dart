import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show ExternalGame, sourceIgdb;

class ExternalGameTileListItem extends StatelessWidget {
  const ExternalGameTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final ExternalGame data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.title,
      subtitle: data.releaseDate == null
          ? null
          : MaterialLocalizations.of(context).formatYear(data.releaseDate!),
      imageURL: data.imageUrl,
      trailing: data.source == sourceIgdb
          ? CommonIcons.externalSourceIgdb
          : CommonIcons.externalSourceDefault,
      onTap: onTap,
    );
  }
}
