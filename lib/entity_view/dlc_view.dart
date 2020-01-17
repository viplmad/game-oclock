import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/dlc.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:game_collection/entity/purchase.dart' as purchaseEntity;

import 'entity_view.dart';

class DLCView extends EntityView {
  DLCView({Key key, @required DLC dlc}) : super(key: key, entity: dlc);

  @override
  State<EntityView> createState() => _DLCViewState();
}

class _DLCViewState extends EntityViewState {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  DLC getEntity() => widget.entity as DLC;

  @override
  Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue) => _db.updateDLC(getEntity().ID, fieldName, newValue);

  @override
  List<Widget> getListFields() {

    return [
      modifyTextAttributeBuilder(
        fieldName: nameField,
        value: getEntity().name,
      ),
      modifyYearAttributeBuilder(
        fieldName: releaseYearField,
        value: getEntity().releaseYear,
      ),
      modifyDateAttributeBuilder(
        fieldName: finishDateField,
        value: getEntity().finishDate,
      ),
      streamBuilderEntity(
          entityStream: _db.getBaseGameFromDLC(getEntity().baseGame),
          tableName: gameEntity.gameTable,
          fieldName: baseGameField,
          newRelationFuture: (int baseGameID) => _db.insertGameDLC(baseGameID, getEntity().ID),
          deleteRelationFuture: (int removedGameID) => _db.deleteGameDLC(getEntity().ID),
      ),streamBuilderEntities(
          entityStream: _db.getPurchasesFromDLC(getEntity().ID),
          tableName: purchaseEntity.purchaseTable,
          newRelationFuture: (int addedPurchaseID) => _db.insertDLCPurchase(getEntity().ID, addedPurchaseID),
          deleteRelationFuture: (int removedPurchaseID) => _db.deleteDLCPurchase(getEntity().ID, removedPurchaseID),
      ),
    ];

  }

}