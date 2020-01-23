import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/store.dart';
import 'package:game_collection/entity/purchase.dart' as purchaseEntity;

import 'entity_view.dart';

class StoreView extends EntityView {
  StoreView({Key key, @required Store store}) : super(key: key, entity: store);

  @override
  State<EntityView> createState() => _StoreViewState();
}

class _StoreViewState extends EntityViewState {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Store getEntity() => widget.entity as Store;

  @override
  Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue) => _db.updateStore(getEntity().ID, fieldName, newValue);

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
      streamBuilderEntities(
        entityStream: _db.getPurchasesFromStore(getEntity().ID),
        tableName: purchaseEntity.purchaseTable,
        newRelationFuture: (int addedPurchaseID) => _db.insertStorePurchase(getEntity().ID, addedPurchaseID),
        deleteRelationFuture: (int deletedPurchaseID) => _db.deleteStorePurchase(deletedPurchaseID),
      ),
    ];

  }

}