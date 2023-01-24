import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart'
    show GameDTO, GameWithFinishDTO, GameWithLogDTO, GameAvailableDTO;

import 'package:backend/model/model.dart' show GameView;

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/bar_data.dart';
import '../utils/shape_utils.dart';
import '../common/triangle_banner.dart';
import 'theme_utils.dart';

class GameTheme {
  GameTheme._();

  static const bool hasImage = true;

  static const Color primaryColour = Colors.red;
  static const Color secondaryColour = Colors.redAccent;

  static const Color lowPriorityStatusColour = Colors.grey;
  static const Color nextUpStatusColour = Colors.redAccent;
  static const Color playingStatusColour = Colors.blueAccent;
  static const Color playedStatusColour = Colors.greenAccent;

  static const Color ratingColour = Color(0xA0B71C1C);
  static const Color ratingBorderColour = secondaryColour;

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
    return GameView.values.map<String>((GameView view) {
      switch (view) {
        case GameView.main:
          return GameCollectionLocalisations.of(context).mainViewString;
        case GameView.lastAdded:
          return GameCollectionLocalisations.of(context).lastAddedViewString;
        case GameView.lastUpdated:
          return GameCollectionLocalisations.of(context).lastUpdatedViewString;
        case GameView.playing:
          return GameCollectionLocalisations.of(context).playingViewString;
        case GameView.nextUp:
          return GameCollectionLocalisations.of(context).nextUpViewString;
        case GameView.lastFinished:
          return GameCollectionLocalisations.of(context).lastFinishedViewString;
        case GameView.lastPlayed:
          return GameCollectionLocalisations.of(context).lastPlayedString;
        case GameView.review:
          return GameCollectionLocalisations.of(context).yearInReviewViewString;
      }
    }).toList(growable: false);
  }

  static Widget itemCard(
    BuildContext context,
    GameDTO item,
    void Function()? Function(BuildContext, GameDTO) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemCard(
        title: itemTitle(item),
        subtitle: _itemSubtitle(context, item),
        hasImage: GameTheme.hasImage,
        imageURL: item.coverUrl,
        onTap: onTap(context, item),
      ),
    );
  }

  static Widget itemCardFinish(
    BuildContext context,
    GameWithFinishDTO item,
    void Function()? Function(BuildContext, GameDTO) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemCard(
        title: itemTitle(item),
        subtitle:
            GameCollectionLocalisations.of(context).formatDate(item.finishDate),
        hasImage: GameTheme.hasImage,
        imageURL: item.coverUrl,
        onTap: onTap(context, item),
      ),
    );
  }

  static Widget itemCardLog(
    BuildContext context,
    GameWithLogDTO item,
    void Function()? Function(BuildContext, GameDTO) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemCard(
        title: itemTitle(item),
        subtitle: GameCollectionLocalisations.of(context)
            .formatDate(item.logDatetime),
        trailing: GameCollectionLocalisations.of(context)
            .formatDuration(item.logTime),
        hasImage: GameTheme.hasImage,
        imageURL: item.coverUrl,
        onTap: onTap(context, item),
      ),
    );
  }

  static Widget itemCardAvailable(
    BuildContext context,
    GameAvailableDTO item,
    void Function()? Function(BuildContext, GameAvailableDTO) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemCard(
        title: itemTitle(item),
        subtitle: GameCollectionLocalisations.of(context)
            .formatDate(item.availableDate),
        hasImage: GameTheme.hasImage,
        imageURL: item.coverUrl,
        onTap: onTap(context, item),
      ),
    );
  }

  static Widget itemCardWithTime(
    BuildContext context,
    GameDTO item,
    Duration totalTime,
    void Function()? Function(BuildContext, GameDTO) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemCard(
        title: itemTitle(item),
        subtitle: _itemSubtitle(context, item),
        trailing:
            GameCollectionLocalisations.of(context).formatDuration(totalTime),
        hasImage: GameTheme.hasImage,
        imageURL: item.coverUrl,
        onTap: onTap(context, item),
      ),
    );
  }

  static Widget _addRatingBanner(GameDTO item, Widget itemView) {
    return item.rating > 0
        ? ClipRRect(
            borderRadius: ShapeUtils.cardBorderRadius,
            child: TriangleBanner(
              message: item.rating.toString(),
              location: TriangleBannerLocation.end,
              showShadow: false,
              color: ratingColour,
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
    GameDTO item,
    void Function()? Function(BuildContext, GameDTO) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemGrid(
        title: itemTitle(item),
        imageURL: item.coverUrl,
        onTap: onTap(context, item),
      ),
    );
  }

  static String itemTitle(GameDTO item) {
    String title = item.name;

    if (item.edition.isNotEmpty) {
      title += ' - ${item.edition}';
    }

    return title;
  }

  static String _itemSubtitle(BuildContext context, GameDTO item) {
    return '${GameCollectionLocalisations.of(context).gameStatusString(item.status)} · ${item.releaseYear != null ? GameCollectionLocalisations.of(context).formatYear(item.releaseYear!) : ''}';
  }
}
