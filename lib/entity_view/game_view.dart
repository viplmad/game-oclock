import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart';
import 'package:game_collection/entity/platform.dart' as platformEntity;
import 'package:game_collection/entity/purchase.dart' as purchaseEntity;
import 'package:game_collection/entity/dlc.dart' as dlcEntity;
import 'package:game_collection/entity/tag.dart' as tagEntity;

import 'entity_view.dart';

class GameView extends EntityView {
  GameView({Key key, @required Game game}) : super(key: key, entity: game);

  @override
  State<EntityView> createState() => _GameViewState();
}

class _GameViewState extends EntityViewState {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Game getEntity() => widget.entity as Game;

  @override
  Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue) => _db.updateGame(getEntity().ID, fieldName, newValue);

  @override
  List<Widget> getListFields() {

    return [
      modifyTextAttributeBuilder(
          fieldName: nameField,
          value: getEntity().name,
          updateLocal: (String newName) {
            setState(() {
              getEntity().name = newName;
            });
          },
      ),
      modifyTextAttributeBuilder(
        fieldName: editionField,
        value: getEntity().edition,
        updateLocal: (String newEdition) {
          setState(() {
            getEntity().edition = newEdition;
          });
        },
      ),
      modifyYearAttributeBuilder(
        fieldName: releaseYearField,
        value: getEntity().releaseYear,
        updateLocal: (int newYear) {
          setState(() {
            getEntity().releaseYear = newYear;
          });
        },
      ),
      modifyEnumAttributeBuilder(
        fieldName: statusField,
        value: getEntity().status,
        listOptions: statuses,
        updateLocal: (String newStatus) {
          setState(() {
            getEntity().status = newStatus;
          });
        },
      ),
      modifyRatingAttributeBuilder(
        fieldName: ratingField,
        value: getEntity().rating,
        updateLocal: (int newRating) {
          setState(() {
            getEntity().rating = newRating;
          });
        },
      ),
      modifyTextAttributeBuilder(
        fieldName: thoughtsField,
        value: getEntity().thoughts,
        updateLocal: (String newThoughts) {
          setState(() {
            getEntity().thoughts = newThoughts;
          });
        },
      ),
      modifyDurationAttributeBuilder(
        fieldName: timeField,
        value: getEntity().time,
        updateLocal: (Duration newTime) {
          setState(() {
            getEntity().time = newTime;
          });
        },
      ),
      modifyTextAttributeBuilder(
        fieldName: saveFolderField,
        value: getEntity().saveFolder,
        updateLocal: (String newSaveFolder) {
          setState(() {
            getEntity().saveFolder = newSaveFolder;
          });
        },
      ),
      modifyTextAttributeBuilder(
        fieldName: screenshotFolderField,
        value: getEntity().screenshotFolder,
        updateLocal: (String newScreenshotFolder) {
          setState(() {
            getEntity().screenshotFolder = newScreenshotFolder;
          });
        },
      ),
      modifyDateAttributeBuilder(
        fieldName: finishDateField,
        value: getEntity().finishDate,
        updateLocal: (DateTime newDate) {
          setState(() {
            getEntity().finishDate = newDate;
          });
        }
      ),
      modifyBoolAttributeBuilder(
        fieldName: backupField,
        value: getEntity().isBackup,
        updateLocal: (bool newBool) {
          setState(() {
            getEntity().isBackup = newBool;
          });
        }
      ),
      /*streamBuilderEntities(
        entityStream: _db.getPurchasesFromGame(getEntity().ID),
        tableName: purchaseEntity.purchaseTable,
        newRelationFuture: (int addedPurchaseID) => _db.insertGamePurchase(getEntity().ID, addedPurchaseID),
        deleteRelationFuture: (int deletedPurchaseID) => _db.deleteGamePurchase(getEntity().ID, deletedPurchaseID),
      ),
      streamBuilderEntities(
        entityStream: _db.getPlatformsFromGame(getEntity().ID),
        tableName: platformEntity.platformTable,
        newRelationFuture: (int addedPlatformID) => _db.insertGamePlatform(getEntity().ID, addedPlatformID),
        deleteRelationFuture: (int deletedPlatformID) => _db.deleteGamePlatform(getEntity().ID, deletedPlatformID),
      ),
      streamBuilderEntities(
        entityStream: _db.getDLCsFromGame(getEntity().ID),
        tableName: dlcEntity.dlcTable,
        newRelationFuture: (int addedDLCID) => _db.insertGameDLC(getEntity().ID, addedDLCID),
        deleteRelationFuture: (int deletedDLCID) => _db.deleteGameDLC(deletedDLCID),
      ),
      streamBuilderEntitiesAsChips(
        entityStream: _db.getTagsFromGame(getEntity().ID),
        allOptionsStream: _db.getAllTags(),
        tableName: tagEntity.tagTable,
        newRelationFuture: (int addedTagID) => _db.insertGameTag(getEntity().ID, addedTagID),
        deleteRelationFuture: (int deletedTagID) => _db.deleteGameTag(getEntity().ID, deletedTagID),
      ),*/
    ];

  }

}