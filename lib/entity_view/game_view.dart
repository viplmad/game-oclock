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
      attributeBuilder(
          fieldName: IDField,
          value: getEntity().ID.toString(),
      ),
      modifyTextAttributeBuilder(
          fieldName: nameField,
          value: getEntity().name,
      ),
      modifyTextAttributeBuilder(
        fieldName: editionField,
        value: getEntity().edition,
      ),
      modifyYearAttributeBuilder(
        fieldName: releaseYearField,
        value: getEntity().releaseYear,
      ),
      /*modifyEnumAttributeBuilder(
        fieldName: statusField,
        value: getEntity().status,
      ),*/
      modifyRatingAttributeBuilder(
        fieldName: ratingField,
        value: getEntity().rating,
      ),
      modifyTextAttributeBuilder(
        fieldName: thoughtsField,
        value: getEntity().thoughts,
        isLongText: true,
      ),
      /*modifyDurationAttributeBuilder(
        fieldName: timeField,
        value: getEntity().time,
      ),*/
      modifyTextAttributeBuilder(
        fieldName: saveFolderField,
        value: getEntity().saveFolder,
        isURL: true,
      ),
      modifyTextAttributeBuilder(
        fieldName: screenshotFolderField,
        value: getEntity().screenshotFolder,
        isURL: true,
      ),
      modifyDateAttributeBuilder(
        fieldName: finishDateField,
        value: getEntity().finishDate,
      ),
      /*modifyBoolAttributeBuilder(
        fieldName: backupField,
        value: getEntity().isBackup,
      ),*/
      Divider(),
      headerRelationText(
        fieldName: purchaseEntity.purchaseTable + 's',
      ),
      streamBuilderEntities(
        entityStream: _db.getPurchasesFromGame(getEntity().ID),
        tableName: purchaseEntity.purchaseTable,
        newRelationFuture: (int addedPurchaseID) => _db.insertGamePurchase(getEntity().ID, addedPurchaseID),
        deleteRelationFuture: (int deletedPurchaseID) => _db.deleteGamePurchase(getEntity().ID, deletedPurchaseID),
      ),
      Divider(),
      headerRelationText(
        fieldName: platformEntity.platformTable + 's',
      ),
      streamBuilderEntities(
        entityStream: _db.getPlatformsFromGame(getEntity().ID),
        tableName: platformEntity.platformTable,
        newRelationFuture: (int addedPlatformID) => _db.insertGamePlatform(getEntity().ID, addedPlatformID),
        deleteRelationFuture: (int deletedPlatformID) => _db.deleteGamePlatform(getEntity().ID, deletedPlatformID),
      ),
      Divider(),
      headerRelationText(
        fieldName: dlcEntity.dlcTable + 's',
      ),
      streamBuilderEntities(
        entityStream: _db.getDLCsFromGame(getEntity().ID),
        tableName: dlcEntity.dlcTable,
        newRelationFuture: (int addedDLCID) => _db.insertGameDLC(getEntity().ID, addedDLCID),
        deleteRelationFuture: (int deletedDLCID) => _db.deleteGameDLC(deletedDLCID),
      ),
      Divider(),
      headerRelationText(
        fieldName: tagEntity.tagTable + 's',
      ),
      streamBuilderEntities(
        entityStream: _db.getTagsFromGame(getEntity().ID),
        tableName: tagEntity.tagTable,
        newRelationFuture: (int addedTagID) => _db.insertGameTag(getEntity().ID, addedTagID),
        deleteRelationFuture: (int deletedTagID) => _db.deleteGameTag(getEntity().ID, deletedTagID),
      ),
    ];

  }

}