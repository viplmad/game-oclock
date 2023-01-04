import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart' show GameDTO, GameAvailableDTO;

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

  static Widget itemAvailableCard(
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
