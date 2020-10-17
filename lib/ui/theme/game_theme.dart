import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';


class GameTheme {

  static const Color primaryColour = Colors.red;
  static const Color accentColour = Colors.redAccent;

  static const List<Color> statusColours = <Color>[
    Colors.grey,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
  ];

  static ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData gameTheme = contextTheme.copyWith(
      primaryColor: primaryColour,
      accentColor: accentColour,
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
      GameCollectionLocalisations.of(context).lastFinishedViewString,
      GameCollectionLocalisations.of(context).yearInReviewViewString,
    ];

  }

  static Widget itemCard(BuildContext context, Game item, Function(BuildContext, Game) onTap) {

    return ItemCard(
      title: itemTitle(item),
      subtitle: _itemSubtitle(item),
      imageURL: item.coverURL?? '',
      onTap: onTap(context, item),
    );

  }

  static Widget itemGrid(BuildContext context, Game item, void Function() Function(BuildContext, Game) onTap) {

    return ItemCard(
      title: itemTitle(item),
      imageURL: item.coverURL?? '',
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

  static String _itemSubtitle(Game item) {

    return (item.status?? '') + ' · ' + item.releaseYear.toString();

  }

}