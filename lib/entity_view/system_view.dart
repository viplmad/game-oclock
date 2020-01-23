import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/system.dart';
import 'package:game_collection/entity/platform.dart' as platformEntity;

import 'entity_view.dart';

class SystemView extends EntityView {
  SystemView({Key key, @required System system}) : super(key: key, entity: system);

  @override
  State<EntityView> createState() => _SystemViewState();
}

class _SystemViewState extends EntityViewState {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  System getEntity() => widget.entity as System;

  @override
  Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue) => _db.updateSystem(getEntity().ID, fieldName, newValue);

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
      modifyIntAttributeBuilder(
        fieldName: generationField,
        value: getEntity().generation,
        updateLocal: (int newGen) {
          setState(() {
            getEntity().generation = newGen;
          });
        }
      ),
      modifyEnumAttributeBuilder(
        fieldName: manufacturerField,
        value: getEntity().manufacturer,
        listOptions: manufacturers,
        updateLocal: (String newManufacturer) {
          setState(() {
            getEntity().manufacturer = newManufacturer;
          });
        }
      ),
      streamBuilderEntities(
        entityStream: _db.getPlatformsFromSystem(getEntity().ID),
        tableName: platformEntity.platformTable,
        newRelationFuture: (int addedPlatformID) => _db.insertPlatformSystem(addedPlatformID, getEntity().ID),
        deleteRelationFuture: (int deletedPlatformID) => _db.deletePlatformSystem(deletedPlatformID, getEntity().ID),
      ),
    ];

  }

}