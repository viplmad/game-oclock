import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show Game;

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/bar_data.dart';
import '../utils/shape_utils.dart';
import '../common/triangle_banner.dart';
import 'theme_utils.dart';

class GameTheme {
  GameTheme._();

  static const Color primaryColour = Colors.red;
  static const Color secondaryColour = Colors.redAccent;

  static const Color lowPriorityStatusColour = Colors.grey;
  static const Color nextUpStatusColour = Colors.redAccent;
  static const Color playingStatusColour = Colors.blueAccent;
  static const Color playedStatusColour = Colors.greenAccent;

  static const Color ratingColour = Colors.yellow;
  static const Color ratingBorderColour = Colors.orangeAccent;

  static const List<Color> statusColours = <Color>[
    lowPriorityStatusColour,
    nextUpStatusColour,
    playingStatusColour,
    playedStatusColour,
  ];

  static ThemeData themeData(BuildContext context) {
    return ThemeUtils.themeByColours(context, primaryColour, secondaryColour);
  }

  static BarData barData(BuildContext context) {
    return BarData(
      title: GameCollectionLocalisations.of(context).gamesString,
      icon: Icons.videogame_asset,
      color: primaryColour,
    );
  }

  static List<String> views(BuildContext context) {
    return <String>[
      GameCollectionLocalisations.of(context).mainViewString,
      GameCollectionLocalisations.of(context).lastCreatedViewString,
      GameCollectionLocalisations.of(context).playingViewString,
      GameCollectionLocalisations.of(context).nextUpViewString,
      GameCollectionLocalisations.of(context).lastPlayedString,
      GameCollectionLocalisations.of(context).lastFinishedViewString,
      GameCollectionLocalisations.of(context).yearInReviewViewString,
    ];
  }

  static Widget itemCard(
    BuildContext context,
    Game item,
    void Function()? Function(BuildContext, Game) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemCard(
        title: itemTitle(item),
        subtitle: _itemSubtitle(context, item),
        hasImage: Game.hasImage,
        imageURL: item.image.url,
        onTap: onTap(context, item),
      ),
    );
  }

  static Widget itemCardWithTime(
    BuildContext context,
    Game item,
    Duration totalTime,
    void Function()? Function(BuildContext, Game) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemCard(
        title: itemTitle(item),
        subtitle: _itemSubtitle(context, item),
        trailing:
            GameCollectionLocalisations.of(context).formatDuration(totalTime),
        hasImage: Game.hasImage,
        imageURL: item.image.url,
        onTap: onTap(context, item),
      ),
    );
  }

  static Widget _addRatingBanner(Game item, Widget itemView) {
    return item.rating > 0
        ? ClipRRect(
            borderRadius: ShapeUtils.cardBorderRadius,
            child: TriangleBanner(
              message: item.rating.toString(),
              location: TriangleBannerLocation.end,
              color: ratingBorderColour,
              textStyle: const TextStyle(
                fontSize: 20,
              ),
              child: itemView,
            ),
          )
        : itemView;
  }

  static Widget itemGrid(
    BuildContext context,
    Game item,
    void Function()? Function(BuildContext, Game) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemGrid(
        title: itemTitle(item),
        imageURL: item.image.url,
        onTap: onTap(context, item),
      ),
    );
  }

  static String itemTitle(Game item) {
    String title = item.name;

    if (item.edition.isNotEmpty) {
      title += ' - ${item.edition}';
    }

    return title;
  }

  static String _itemSubtitle(BuildContext context, Game item) {
    return '${GameCollectionLocalisations.of(context).gameStatusString(item.status)} · ${item.releaseYear != null ? GameCollectionLocalisations.of(context).formatYear(item.releaseYear!) : ''}';
  }
}
