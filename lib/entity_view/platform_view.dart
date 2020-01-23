import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/platform.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:game_collection/entity/system.dart' as systemEntity;

import 'entity_view.dart';

class PlatformView extends EntityView {
  PlatformView({Key key, @required Platform platform}) : super(key: key, entity: platform);

  @override
  State<EntityView> createState() => _PlatformViewState();
}

class _PlatformViewState extends EntityViewState {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  Platform getEntity() => widget.entity as Platform;

  @override
  Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue) => _db.updatePlatform(getEntity().ID, fieldName, newValue);

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
      modifyEnumAttributeBuilder(
        fieldName: typeField,
        value: getEntity().type,
        listOptions: types,
        updateLocal: (String newType) {
          setState(() {
            getEntity().type = newType;
          });
        }
      ),
      streamBuilderEntities(
        entityStream: _db.getGamesFromPlatform(getEntity().ID),
        tableName: gameEntity.gameTable,
        newRelationFuture: (int addedGameID) => _db.insertGamePlatform(addedGameID, getEntity().ID),
        deleteRelationFuture: (int deletedGameID) => _db.deleteGamePlatform(deletedGameID, getEntity().ID),
      ),
      streamBuilderEntities(
        entityStream: _db.getSystemsFromPlatform(getEntity().ID),
        tableName: systemEntity.systemTable,
        newRelationFuture: (int addedSystemID) => _db.insertPlatformSystem(getEntity().ID, addedSystemID),
        deleteRelationFuture: (int deletedSystemID) => _db.deletePlatformSystem(getEntity().ID, deletedSystemID),
      ),
    ];

  }

}