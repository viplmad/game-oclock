import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


const Color gameColour = Colors.red;

class GameDetail extends StatelessWidget {

  const GameDetail({Key key, @required this.ID}) : super(key: key);

  final int ID;

  @override
  Widget build(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData gameTheme = contextTheme.copyWith(
      primaryColor: gameColour,
      accentColor: Colors.redAccent,
    );

    return Scaffold(
      body: Theme(
        data: gameTheme,
        child: _GameDetailBody(
          itemID: ID,
          itemDetailBloc: BlocProvider.of<GameDetailBloc>(context)..add(LoadItem(ID)),
        ),
      ),
    );

  }

}

const List<Color> statusColours = [
  Colors.grey,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.greenAccent,
];

class _GameDetailBody extends ItemDetailBody {

  _GameDetailBody({
    Key key,
    @required int itemID,
    @required ItemDetailBloc itemDetailBloc,
  }) : super(
    key: key,
    itemID: itemID,
    itemDetailBloc: itemDetailBloc,
  );

  @override
  List<Widget> itemFieldsBuilder(CollectionItem item) {

    Game game = (item as Game);

    return [
      itemTextField(
        fieldName: game_nameField,
        value: game.name,
      ),
      itemTextField(
        fieldName: game_editionField,
        value: game.edition,
      ),
      itemYearField(
        fieldName: game_releaseYearField,
        value: game.releaseYear,
      ),
      itemChipField(
        fieldName: game_statusField,
        value: game.status,
        possibleValues: statuses,
        possibleValuesColours: statusColours,
      ),
      itemRatingField(
        fieldName: game_ratingField,
        value: game.rating,
      ),
      itemLongTextField(
        fieldName: game_thoughtsField,
        value: game.thoughts,
      ),
      itemDurationField(
        fieldName: game_timeField,
        value: game.time,
      ),
      itemURLField(
        fieldName: game_saveFolderField,
        value: game.saveFolder,
      ),
      itemURLField(
        fieldName: game_screenshotFolderField,
        value: game.screenshotFolder,
      ),
      itemDateTimeField(
        fieldName: game_finishDateField,
        value: game.finishDate,
      ),
      itemBoolField(
        fieldName: game_backupField,
        value: game.isBackup,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      itemListManyRelation(
        itemType: Platform,
      ),
      itemListManyRelation(
        itemType: Purchase,
      ),
      itemListManyRelation(
        itemType: DLC,
      ),
      itemListManyRelation( //TODO: show as chips
        itemType: Tag,
      ),
    ];

  }

  @override
  GameRelationBloc itemRelationBlocFunction(Type itemType) {

    return GameRelationBloc(
      gameID: itemID,
      relationType: itemType,
      itemBloc: itemBloc,
    );

  }

}