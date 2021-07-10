import 'package:query/query.dart';

import 'package:backend/entity/entity.dart';


class DLCFinishRepository {
  DLCFinishRepository._();

  static Query create(DLCFinishEntity entity, int dlcId) {
    final Query query = FluentQuery
      .insert()
      .into(DLCFinishEntityData.table)
      .sets(entity.createMap(dlcId));

    return query;
  }

  static Query deleteById(int dlcId, DateTime date) {
    final Query query = FluentQuery
      .delete()
      .from(DLCFinishEntityData.table);

    _addIdWhere(dlcId, date, query);

    return query;
  }

  static Query selectAllByDLC(int id) {
    final Query query = FluentQuery
      .select()
      .from(DLCFinishEntityData.table)
      .where(DLCFinishEntityData.dlcField, id, type: int, table: DLCFinishEntityData.table);

    addFields(query);

    return query;
  }

  static void addFields(Query query) {
    query.field(DLCFinishEntityData.dlcField, type: int, table: DLCFinishEntityData.table);
    query.field(DLCFinishEntityData.dateField, type: DateTime, table: DLCFinishEntityData.table);
  }

  static void _addIdWhere(int dlcId, DateTime date, Query query) {
    query.where(DLCFinishEntityData.dlcField, dlcId, type: int, table: DLCFinishEntityData.table);
    query.where(DLCFinishEntityData.dateField, date, type: DateTime, table: DLCFinishEntityData.table);
  }
}