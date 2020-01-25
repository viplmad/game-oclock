import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_connector.dart';
import 'package:game_collection/persistence/db_manager.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/tag.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;

import 'entity_view.dart';

class TagView extends EntityView {
  TagView({Key key, @required Tag tag}) : super(key: key, entity: tag);

  @override
  State<EntityView> createState() => _TagViewState();
}

class _TagViewState extends EntityViewState {
  final DBConnector _db = DBManager().getConnector();

  @override
  Tag getEntity() => widget.entity as Tag;

  @override
  Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue) => _db.updateTag(getEntity().ID, fieldName, newValue);

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
        entityStream: _db.getGamesFromTag(getEntity().ID),
        tableName: gameEntity.gameTable,
        newRelationFuture: (int addedGameID) => _db.insertGameTag(addedGameID, getEntity().ID),
        deleteRelationFuture: (int deletedGameID) => _db.deleteGameTag(deletedGameID, getEntity().ID),
      ),
    ];

  }

}