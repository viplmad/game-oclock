import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart'
    show GridListItem, TileListItem;
import 'package:game_oclock/models/models.dart' show UserGame;
import 'package:game_oclock/utils/localisation_extension.dart';

class UserGameGridListItem extends StatelessWidget {
  const UserGameGridListItem({super.key, required this.data, this.onTap});

  final UserGame data;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return GridListItem(
      title: data.edition.isEmpty
          ? data.title
          : context.localize().gameEditionDataTitle(data.title, data.edition),
      imageURL: data.coverUrl,
      onTap: onTap,
    );
  }
}

class UserGameTileListItem extends StatelessWidget {
  const UserGameTileListItem({super.key, required this.data, this.onTap});

  final UserGame data;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.edition.isEmpty
          ? data.title
          : context.localize().gameEditionDataTitle(data.title, data.edition),
      imageURL: data.coverUrl,
      onTap: onTap,
    );
  }
}
