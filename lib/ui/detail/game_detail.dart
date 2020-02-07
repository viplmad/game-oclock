import 'package:flutter/material.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

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
  List<Widget> itemDetailFields(BuildContext context) {

    Game game = (item as Game);

    return [
      ItemTextField(
        fieldName: game_nameField,
        value: game.name,
        update: (String newName) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_nameField,
              newName,
            ),
          );
        },
      ),
      ItemTextField(
        fieldName: game_editionField,
        value: game.edition,
        update: (String newName) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_editionField,
              newName,
            ),
          );
        },
      ),
      ItemYearField(
        fieldName: game_releaseYearField,
        value: game.releaseYear,
        update: (int newYear) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_releaseYearField,
              newYear,
            ),
          );
        },
      ),
      ItemTextField( //TODO: EnumField
        fieldName: game_statusField,
        value: game.status,
        update: (String newStatus) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_statusField,
              newStatus,
            ),
          );
        },
      ),
      RatingField(
        fieldName: game_ratingField,
        value: game.rating,
        update: (int newRating) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_ratingField,
              newRating,
            ),
          );
        },
      ),
      ItemTextField(
        fieldName: game_thoughtsField,
        value: game.thoughts,
        update: (String newThoughts) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_thoughtsField,
              newThoughts,
            ),
          );
        },
      ),
      ItemDurationField(
        fieldName: game_timeField,
        value: game.time,
        update: (Duration newTime) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_timeField,
              newTime,
            ),
          );
        },
      ),
      ItemTextField(
        fieldName: game_saveFolderField,
        value: game.saveFolder,
        update: (String newFolder) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_saveFolderField,
              newFolder,
            ),
          );
        },
      ),
      ItemTextField(
        fieldName: game_screenshotFolderField,
        value: game.screenshotFolder,
        update: (String newFolder) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_screenshotFolderField,
              newFolder,
            ),
          );
        },
      ),
      ItemDateTimeField(
        fieldName: game_finishDateField,
        value: game.finishDate,
        update: (DateTime newDate) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_finishDateField,
              newDate,
            ),
          );
        },
      ),
      BoolField(
        fieldName: game_backupField,
        value: game.isBackup,
        update: (bool newBackup) {
          itemBloc.add(
            UpdateItemField(
              game,
              game_backupField,
              newBackup,
            ),
          );
        },
      ),
    ];

  }

}