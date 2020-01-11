import 'package:flutter/material.dart';
import 'package:game_collection/entity_view/entity_view.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/dlc.dart';
import 'package:game_collection/entity/game.dart' as game;
import 'package:game_collection/entity/purchase.dart';

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
      attributeBuilder(
        fieldName: nameField,
        value: getEntity().name.toString(),
      ),
      attributeBuilder(
        fieldName: releaseYearField,
        value: getEntity().releaseYear.toString(),
      ),
      attributeBuilder(
        fieldName: finishDateField,
        value: getEntity().finishDate?.toIso8601String() ?? "Unknown",
      ),
      streamBuilderEntity(
          entityStream: _db.getBaseGameFromDLC(getEntity().baseGame),
          tableName: game.gameTable,
          addText: "Add " + baseGameField,
      ),
      streamBuilderEntities(
          entityStream: _db.getPurchasesFromDLC(getEntity().ID),
          tableName: purchaseTable,
          addText: "Add " + purchaseTable,
      ),
    ];

  }

}