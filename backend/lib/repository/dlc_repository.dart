import 'package:query/query.dart';

import 'repository.dart';
import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';


class DLCRepository {
  DLCRepository._();

  static Query create(DLCEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(DLCEntityData.table)
      .sets(entity.createMap())
      .returningField(DLCEntityData.idField);

    return query;
  }

  static Query updateById(int id, DLCEntity entity, DLCEntity updatedEntity, DLCUpdateProperties updateProperties) {
    final Query query = FluentQuery
      .update()
      .table(DLCEntityData.table)
      .sets(entity.updateMap(updatedEntity, updateProperties));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateCoverById(int id, String? coverName) {
    final Query query = FluentQuery
      .update()
      .table(DLCEntityData.table)
      .set(DLCEntityData.coverField, coverName);

    _addIdWhere(id, query);

    return query;
  }

  static Query updateBaseGameById(int id, int? baseGame) {
    final Query query = FluentQuery
      .update()
      .table(DLCEntityData.table)
      .set(DLCEntityData.baseGameField, baseGame);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(int id) {
    final Query query = FluentQuery
      .delete()
      .from(DLCEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(int id) {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAllByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table)
      .where(DLCEntityData.nameField, name, type: String, table: DLCEntityData.table, operator: OperatorType.LIKE)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(DLCView view, [int? limit]) {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table)
      .limit(limit);

    addFields(query);
    _addViewWhere(query, view);
    _addViewOrder(query, view);

    return query;
  }

  static Query selectAllByBaseGame(int id) {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table)
      .where(DLCEntityData.baseGameField, id, type: int, table: DLCEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectGameByDLC(int id) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table)
      .join(DLCEntityData.table, null, DLCEntityData.baseGameField, GameEntityData.table, GameEntityData.idField)
      .where(DLCEntityData.idField, id, type: int, table: DLCEntityData.table);

    GameRepository.addFields(query);

    return query;
  }

  static void addFields(Query query) {
    query.field(DLCEntityData.idField, type: int, table: DLCEntityData.table);
    query.field(DLCEntityData.nameField, type: String, table: DLCEntityData.table);
    query.field(DLCEntityData.releaseYearField, type: int, table: DLCEntityData.table);
    query.field(DLCEntityData.coverField, type: String, table: DLCEntityData.table);
    query.field(DLCEntityData.finishDateField, type: DateTime, table: DLCEntityData.table);

    query.field(DLCEntityData.baseGameField, type: int, table: DLCEntityData.table);
  }

  static void _addIdWhere(int id, Query query) {
    query.where(DLCEntityData.idField, id, type: int, table: DLCEntityData.table);
  }

  static void _addViewWhere(Query query, DLCView view) {
    switch(view) {
      case DLCView.Main:
        // TODO: Handle this case.
        break;
      case DLCView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }

  static void _addViewOrder(Query query, DLCView view) {
    switch(view) {
      case DLCView.Main:
        // TODO: Handle this case.
        break;
      case DLCView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }
}