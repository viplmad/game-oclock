import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

class TagMediaTileListItem extends StatelessWidget {
  const TagMediaTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final TagMediaDTO data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.tag.name,
      subtitle: data.tagged.order.toString(),
      onTap: onTap,
    );
  }
}

class MediaTagTileListItem extends StatelessWidget {
  const MediaTagTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final MediaTagDTO data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.media.media.edition.isEmpty
          ? data.media.media.title
          : context.localize().gameEditionDataTitle(
              data.media.media.title,
              data.media.media.edition,
            ),
      subtitle: data.tagged.order.toString(),
      imageURL: data.media.media.imageUrl,
      onTap: onTap,
    );
  }
}
