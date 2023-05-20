import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_collection_client/api.dart'
    show
        GameAvailableDTO,
        GameDTO,
        GameStatus,
        GameWithFinishDTO,
        GameWithLogDTO;

import 'package:logic/model/model.dart' show GameView;

import 'package:game_collection/ui/common/item_view.dart';
import 'package:game_collection/ui/common/bar_data.dart';
import 'package:game_collection/ui/common/triangle_banner.dart';
import 'package:game_collection/ui/utils/shape_utils.dart';
import 'package:game_collection/ui/utils/theme_utils.dart';
import 'package:game_collection/ui/utils/app_localizations_utils.dart';

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
      title: AppLocalizations.of(context)!.gamesString,
      icon: Icons.videogame_asset,
      color: primaryColour,
    );
  }

  static List<String> views(BuildContext context) {
    return GameView.values
        .map<String>((GameView view) => _viewString(context, view))
        .toList(growable: false);
  }

  static String _viewString(BuildContext context, GameView view) {
    switch (view) {
      case GameView.main:
        return AppLocalizations.of(context)!.mainViewString;
      case GameView.lastAdded:
        return AppLocalizations.of(context)!.lastAddedViewString;
      case GameView.lastUpdated:
        return AppLocalizations.of(context)!.lastUpdatedViewString;
      case GameView.playing:
        return AppLocalizations.of(context)!.playingViewString;
      case GameView.nextUp:
        return AppLocalizations.of(context)!.nextUpViewString;
      case GameView.lastFinished:
        return AppLocalizations.of(context)!.lastFinishedViewString;
      case GameView.lastPlayed:
        return AppLocalizations.of(context)!.lastPlayedString;
      case GameView.review:
        return AppLocalizations.of(context)!.yearInReviewViewString;
    }
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
        subtitle: MaterialLocalizations.of(context)
            .formatCompactDate(item.finishDate),
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
        subtitle: MaterialLocalizations.of(context)
            .formatCompactDate(item.logDatetime),
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
        subtitle: MaterialLocalizations.of(context)
            .formatCompactDate(item.availableDate),
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
        trailing: AppLocalizationsUtils.formatDuration(context, totalTime),
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
    return '${_statusString(context, item.status)} · ${item.releaseYear ?? ''}';
  }

  static String _statusString(BuildContext context, GameStatus? status) {
    switch (status) {
      case GameStatus.lowPriority:
        return AppLocalizations.of(context)!.lowPriorityString;
      case GameStatus.nextUp:
        return AppLocalizations.of(context)!.nextUpString;
      case GameStatus.playing:
        return AppLocalizations.of(context)!.playingString;
      case GameStatus.played:
        return AppLocalizations.of(context)!.playedString;
      default:
        return '';
    }
  }
}
