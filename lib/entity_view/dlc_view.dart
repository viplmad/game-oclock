import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/dlc.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:game_collection/entity/purchase.dart';

import 'entity_view.dart';

class DLCView extends EntityView {
  DLCView({Key key, @required DLC dlc}) : super(key: key, entity: dlc);

  @override
  State<EntityView> createState() => _DLCViewState();
}

class _DLCViewState extends EntityViewState {
  final DBConnector _db = PostgresConnector.getConnector();

  DLC getEntity() => widget.entity as DLC;

  @override
  List<Widget> getListFields() {

    return [
      attributeBuilder(
          fieldName: IDField,
          value: getEntity().ID.toString(),
      ),
      modifyTextAttributeBuilder(
        fieldName: nameField,
        value: getEntity().name.toString(),
        handleUpdate: (String newName) {
          _db.updateStringDLC(getEntity().ID, nameField, newName).then( (dynamic data) {

            showSnackBar("Updated");

          }, onError: (e) {

            showSnackBar("Unable to update");

          });
        }
      ),
      modifyYearAttributeBuilder(
        fieldName: releaseYearField,
        value: getEntity().releaseYear.toString(),
        handleUpdate: (int newYear) {
          _db.updateNumberDLC(getEntity().ID, releaseYearField, newYear).then( (dynamic data) {

            showSnackBar("Updated");

          }, onError: (e) {

            showSnackBar("Unable to update");

          });
        }
      ),
      modifyDateAttributeBuilder(
        fieldName: finishDateField,
        value: getEntity().finishDate?.toIso8601String() ?? "Unknown",
        handleUpdate: (DateTime newDate) {
          _db.updateDateDLC(getEntity().ID, finishDateField, newDate).then( (dynamic data) {

            showSnackBar("Updated");

          }, onError: (e) {

            showSnackBar("Unable to update");

          });
        }
      ),
      Divider(),
      headerRelationText(
          fieldName: baseGameField,
      ),
      streamBuilderEntity(
          entityStream: _db.getBaseGameFromDLC(getEntity().baseGame),
          tableName: gameEntity.gameTable,
          addText: "Add " + baseGameField,
          handleNew: (gameEntity.Game addedGame) {
            _db.insertGameDLC(addedGame.ID, getEntity().ID).then( (dynamic data) {

              showSnackBar("Added " + addedGame.getFormattedTitle());

            }, onError: (e) {

              showSnackBar("Unable to add " + addedGame.getFormattedTitle());

            });
          },
          handleDelete: (gameEntity.Game addedGame) {
            _db.deleteGameDLC(getEntity().ID).then( (dynamic data) {

              showSnackBar("Deleted " + addedGame.getFormattedTitle());

            }, onError: (e) {

              showSnackBar("Unable to delete " + addedGame.getFormattedTitle());

            });
          },
      ),
      Divider(),
      headerRelationText(
        fieldName: purchaseTable + 's',
      ),
      streamBuilderEntities(
          entityStream: _db.getPurchasesFromDLC(getEntity().ID),
          tableName: purchaseTable,
      ),
    ];

  }

}