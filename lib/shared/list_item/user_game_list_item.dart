import 'package:flutter/material.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/list/list_item.dart'
    show GridListItem, TileListItem;
import 'package:game_oclock/components/triangle_banner.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/models/models.dart'
    show UserGame, gameStatusOptions;
import 'package:game_oclock/utils/localisation_extension.dart';

class UserGameTileListItem extends StatelessWidget {
  const UserGameTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final UserGame data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final listItem = TileListItem(
      title: data.edition.isEmpty
          ? data.title
          : context.localize().gameEditionDataTitle(data.title, data.edition),
      subtitle: data.releaseDate == null
          ? null
          : MaterialLocalizations.of(context).formatYear(data.releaseDate!),
      trailing: LabelChoiceChip(value: data.status, options: gameStatusOptions),
      imageURL: data.imageUrl,
      onTap: onTap,
    );

    return addRatingBanner(listItem, data.rating);
  }
}

class UserGameGridListItem extends StatelessWidget {
  const UserGameGridListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final UserGame data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final listItem = GridListItem(
      title: data.edition.isEmpty
          ? data.title
          : context.localize().gameEditionDataTitle(data.title, data.edition),
      imageURL: data.imageUrl,
      onTap: onTap,
    );

    return addRatingBanner(listItem, data.rating);
  }
}

Widget addRatingBanner(final Widget listItem, final int rating) {
  return rating > 0
      ? TriangleBanner(
          message: rating.toString(),
          location: TriangleBannerLocation.end,
          showShadow: false,
          color: CommonColors.ratingColor,
          textStyle: const TextStyle(
            color: CommonColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
          child: listItem,
        )
      : listItem;
}
