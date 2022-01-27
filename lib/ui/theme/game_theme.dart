import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/bar_data.dart';


class GameTheme {
  GameTheme._();

  static const Color primaryColour = Colors.red;
  static const Color secondaryColour = Colors.redAccent;

  static const Color lowPriorityStatusColour = Colors.grey;
  static const Color nextUpStatusColour = Colors.redAccent;
  static const Color playingStatusColour = Colors.blueAccent;
  static const Color playedStatusColour = Colors.greenAccent;

  static const List<Color> statusColours = <Color>[
    lowPriorityStatusColour,
    nextUpStatusColour,
    playingStatusColour,
    playedStatusColour,
  ];

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData gameTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      colorScheme: contextTheme.colorScheme.copyWith(
        primary: primaryColour,
        secondary: secondaryColour,
      ),
    );

    return gameTheme;

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

  static Widget itemCard(BuildContext context, Game item, void Function()? Function(BuildContext, Game) onTap) {

    return ItemCard(
      title: itemTitle(item),
      subtitle: _itemSubtitle(context, item),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static Widget itemCardWithTime(BuildContext context, Game item, Duration totalTime, void Function()? Function(BuildContext, Game) onTap) {

    return ItemCard(
      title: itemTitle(item),
      subtitle: _itemSubtitle(context, item),
      trailing: GameCollectionLocalisations.of(context).formatDuration(totalTime),
      hasImage: item.hasImage,
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, Game item, void Function()? Function(BuildContext, Game) onTap) {

    return ItemGrid(
      title: itemTitle(item),
      imageURL: item.image.url,
      onTap: onTap(context, item),
    );

  }

  static String itemTitle(Game item) {

    String title = item.name;

    if(item.edition.isNotEmpty) {
      title += ' - ' + item.edition;
    }

    return title;

  }

  static String _itemSubtitle(BuildContext context, Game item) {

    return GameCollectionLocalisations.of(context).gameStatusString(item.status) + ' · ' + (item.releaseYear != null? GameCollectionLocalisations.of(context).formatYear(item.releaseYear!) : '');

  }
}