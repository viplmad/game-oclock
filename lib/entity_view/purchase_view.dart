import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/purchase.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:game_collection/entity/dlc.dart' as dlcEntity;
import 'package:game_collection/entity/store.dart' as storeEntity;
import 'package:game_collection/entity/type.dart' as typeEntity;

import 'entity_view.dart';

class PurchaseView extends EntityView {
  PurchaseView({Key key, @required Purchase purchase}) : super(key: key, entity: purchase);

  @override
  State<EntityView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends EntityViewState {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Purchase getEntity() => widget.entity as Purchase;

  @override
  Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue) => _db.updatePurchase(getEntity().ID, fieldName, newValue);

  @override
  List<Widget> getListFields() {

    return [
      modifyTextAttributeBuilder(
        fieldName: descriptionField,
        value: getEntity().description,
        updateLocal: (String newDesc) {
          setState(() {
            getEntity().description = newDesc;
          });
        },
      ),
      modifyMoneyAttributeBuilder(
        fieldName: priceField,
        value: getEntity().price,
        updateLocal: (double newMoney) {
          setState(() {
            getEntity().price = newMoney;
          });
        },
      ),
      modifyMoneyAttributeBuilder(
        fieldName: externalCreditField,
        value: getEntity().externalCredit,
        updateLocal: (double newMoney) {
          setState(() {
            getEntity().externalCredit = newMoney;
          });
        },
      ),
      modifyDateAttributeBuilder(
        fieldName: dateField,
        value: getEntity().date,
        updateLocal: (DateTime newDate) {
          setState(() {
            getEntity().date = newDate;
          });
        }
      ),
      modifyMoneyAttributeBuilder(
        fieldName: originalPriceField,
        value: getEntity().originalPrice,
        updateLocal: (double newMoney) {
          setState(() {
            getEntity().originalPrice = newMoney;
          });
        },
      ),
      streamBuilderEntity(
        entityStream: _db.getStoreFromPurchase(getEntity().store),
        tableName: storeEntity.storeTable,
        fieldName: storeField,
        newRelationFuture: (int addedStoreID) => _db.insertStorePurchase(addedStoreID, getEntity().ID),
        deleteRelationFuture: (int deletedStoreID) => _db.deleteStorePurchase(getEntity().ID),
      ),
      streamBuilderEntities(
        entityStream: _db.getGamesFromPurchase(getEntity().ID),
        tableName: gameEntity.gameTable,
        newRelationFuture: (int addedGameID) => _db.insertGamePurchase(addedGameID, getEntity().ID),
        deleteRelationFuture: (int deletedGameID) => _db.deleteGamePurchase(deletedGameID, getEntity().ID),
      ),
      streamBuilderEntities(
        entityStream: _db.getDLCsFromPurchase(getEntity().ID),
        tableName: dlcEntity.dlcTable,
        newRelationFuture: (int addedDLCID) => _db.insertDLCPurchase(addedDLCID, getEntity().ID),
        deleteRelationFuture: (int deletedDLCID) => _db.deleteDLCPurchase(deletedDLCID, getEntity().ID),
      ),
      /*streamBuilderEntitiesAsChips(
        entityStream: _db.getTypesFromPurchase(getEntity().ID),
        allOptionsStream: _db.getAllTypes(),
        tableName: typeEntity.typeTable,
        newRelationFuture: (int addedTypeID) => _db.insertPurchaseType(getEntity().ID, addedTypeID),
        deleteRelationFuture: (int deletedTypeID) => _db.deletePurchaseType(getEntity().ID, deletedTypeID),
      ),*/
    ];

  }

}