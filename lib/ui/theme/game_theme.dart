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

import 'package:game_oclock/ui/common/item_view.dart';
import 'package:game_oclock/ui/common/bar_data.dart';
import 'package:game_oclock/ui/common/triangle_banner.dart';
import 'package:game_oclock/ui/utils/theme_utils.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

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

  static List<Color> chartColors = <Color>[
    Colors.redAccent,
    Colors.deepPurpleAccent,
    Colors.blueAccent,
    Colors.lightGreen[700]!,
    Colors.deepOrangeAccent,
    Colors.blueGrey,
    Colors.lime[900]!,
    Colors.indigoAccent,
    Colors.pinkAccent,
    Colors.cyan[700]!,
    Colors.purple[300]!,
    Colors.orangeAccent,
  ];

  static const IconData primaryIcon = Icons.videogame_asset_outlined;
  static const IconData sessionIcon = Icons.schedule;
  static const IconData finishIcon = Icons.emoji_events_outlined;
  static const IconData longestSessionIcon = Icons.timelapse;
  static const IconData longestStreakIcon = Icons.browse_gallery_outlined;
  static const IconData firstPlayedIcon = Icons.fiber_new_outlined;
  static const IconData notFirstPlayedIcon = Icons.history;
  static const IconData firstFinishedIcon = finishIcon;
  static const IconData notFirstFinishedIcon =
      Icons.event_repeat_outlined; // TODO
  static const IconData firstIcon = Icons.looks_one_outlined;
  static const IconData secondIcon = Icons.looks_two_outlined;
  static const IconData thirdIcon = Icons.looks_3_outlined;
  static const IconData fourthIcon = Icons.looks_4_outlined;
  static const IconData fifthIcon = Icons.looks_5_outlined;

  static ThemeData themeData(BuildContext context) {
    return ThemeUtils.themeByColours(context, primaryColour, secondaryColour);
  }

  static BarData barData(BuildContext context) {
    return BarData(
      title: AppLocalizations.of(context)!.gamesString,
      iconData: primaryIcon,
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
        subtitle: AppLocalizationsUtils.formatDate(item.finishDate),
        hasImage: GameTheme.hasImage,
        imageURL: item.coverUrl,
        onTap: onTap(context, item),
      ),
    );
  }

  static Widget itemCardLog(
    BuildContext context,
    GameWithLogDTO item,
    void Function()? Function(BuildContext, GameDTO) onTap, {
    required bool isLastPlayed,
  }) {
    return _addRatingBanner(
      item,
      ItemCard(
        title: itemTitle(item),
        subtitle: isLastPlayed
            ? AppLocalizationsUtils.formatDate(item.logEndDatetime)
            : AppLocalizationsUtils.formatDate(item.logStartDatetime),
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
        subtitle: AppLocalizationsUtils.formatDate(item.availableDate),
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
            Text(AppLocalizationsUtils.formatDuration(context, totalTime)),
        hasImage: GameTheme.hasImage,
        imageURL: item.coverUrl,
        onTap: onTap(context, item),
      ),
    );
  }

  static Widget itemCardWithAdditionalWidgets(
    BuildContext context,
    GameDTO item,
    Widget trailing,
    List<Widget> additionalWidgets,
    void Function()? Function(BuildContext, GameDTO) onTap,
  ) {
    return _addRatingBanner(
      item,
      ItemCard(
        title: itemTitle(item),
        subtitle: _itemSubtitle(context, item),
        trailing: trailing,
        hasImage: GameTheme.hasImage,
        imageURL: item.coverUrl,
        onTap: onTap(context, item),
        additionalWidgets: additionalWidgets,
      ),
    );
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

  static Widget _addRatingBanner(GameDTO item, Widget itemView) {
    return item.rating > 0
        ? TriangleBanner(
            message: item.rating.toString(),
            location: TriangleBannerLocation.end,
            showShadow: false,
            color: ratingColour,
            textStyle: const TextStyle(
              fontSize: 20,
            ),
            child: itemView,
          )
        : itemView;
  }

  static String itemTitle(GameDTO item) {
    String title = item.name;

    if (item.edition.isNotEmpty) {
      title += ' - ${item.edition}';
    }

    return title;
  }

  static String _itemSubtitle(BuildContext context, GameDTO item) {
    String subtitle = _statusString(context, item.status);

    if (item.releaseYear != null) {
      subtitle += ' · ${item.releaseYear}';
    }

    return subtitle;
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
      case GameStatus.wishlist:
        return AppLocalizations.of(context)!.wishlistString;
      default:
        return '';
    }
  }
}
