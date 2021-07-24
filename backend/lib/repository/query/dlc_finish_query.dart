import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show DLCFinishEntity, DLCFinishID, DLCID, DLCFinishEntityData;


class DLCFinishQuery {
  DLCFinishQuery._();

  static Query create(DLCFinishEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(DLCFinishEntityData.table)
      .sets(entity.createMap());

    return query;
  }

  static Query updateById(DLCFinishID id, DLCFinishEntity entity, DLCFinishEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(DLCFinishEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(DLCFinishID id) {
    final Query query = FluentQuery
      .delete()
      .from(DLCFinishEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(DLCFinishID id) {
    final Query query = FluentQuery
      .select()
      .from(DLCFinishEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(DLCFinishEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByDLC(DLCID id) {
    final Query query = FluentQuery
      .select()
      .from(DLCFinishEntityData.table)
      .where(DLCFinishEntityData.dlcField, id.id, type: int, table: DLCFinishEntityData.table);

    addFields(query);

    return query;
  }

  static void addFields(Query query) {
    query.field(DLCFinishEntityData.dlcField, type: int, table: DLCFinishEntityData.table);
    query.field(DLCFinishEntityData.dateField, type: DateTime, table: DLCFinishEntityData.table);
  }

  static void _addIdWhere(DLCFinishID id, Query query) {
    query.where(DLCFinishEntityData.dlcField, id.dlcId, type: int, table: DLCFinishEntityData.table);
    query.where(DLCFinishEntityData.dateField, id.dateTime, type: DateTime, table: DLCFinishEntityData.table);
  }
}