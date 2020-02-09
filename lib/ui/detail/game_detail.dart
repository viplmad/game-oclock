import 'package:flutter/material.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


class GameDetail extends StatelessWidget {

  const GameDetail({Key key, @required this.ID, @required this.itemDetailBloc}) : super(key: key);

  final int ID;
  final ItemDetailBloc itemDetailBloc;

  ItemBloc get itemBloc => itemDetailBloc.itemBloc;

  @override
  Widget build(BuildContext context) {

    itemDetailBloc.add(LoadItem(ID));

    return Scaffold(
      body: _GameDetailBody(
        itemID: ID,
        itemDetailBloc: itemDetailBloc,
      ),
    );

  }

}

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
  List<Widget> itemFieldsBuilder(BuildContext context) {

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
      itemTextField( //TODO: EnumField
        fieldName: game_statusField,
        value: game.status,
      ),
      itemRatingField(
        fieldName: game_ratingField,
        value: game.rating,
      ),
      itemTextField(
        fieldName: game_thoughtsField,
        value: game.thoughts,
      ),
      itemDurationField(
        fieldName: game_timeField,
        value: game.time,
      ),
      itemTextField(
        fieldName: game_saveFolderField,
        value: game.saveFolder,
      ),
      itemTextField(
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
      itemsManyRelation(
        tableName: platformTable,
      ),
      itemsManyRelation(
        tableName: purchaseTable,
      ),
      itemsManyRelation(
        tableName: dlcTable,
      ),
      itemsManyRelation( //TODO: show as chips
        tableName: tagTable,
      ),
    ];

  }

  @override
  GameRelationBloc itemRelationBlocFunction(String tableName) {

    return GameRelationBloc(
      gameID: itemID,
      relationField: tableName,
      itemBloc: itemBloc,
    );

  }

}