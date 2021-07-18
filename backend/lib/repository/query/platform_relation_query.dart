import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show PlatformEntityData, SystemEntityData, PlatformSystemRelationData;

import 'query.dart' show PlatformQuery, SystemQuery;


class PlatformSystemRelationQuery {
  PlatformSystemRelationQuery._();

  static Query create(int platformId, int systemId) {
    final Query query = FluentQuery
      .insert()
      .into(PlatformSystemRelationData.table)
      .set(PlatformSystemRelationData.platformField, platformId)
      .set(PlatformSystemRelationData.systemField, systemId);

    return query;
  }

  static Query deleteById(int platformId, int systemId) {
    final Query query = FluentQuery
      .delete()
      .from(PlatformSystemRelationData.table);

    _addIdWhere(platformId, systemId, query);

    return query;
  }

  static Query selectAllPlatformsBySystemId(int id) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table)
      .join(PlatformSystemRelationData.table, null, PlatformSystemRelationData.platformField, PlatformEntityData.table, PlatformEntityData.idField)
      .where(PlatformSystemRelationData.systemField, id, type: int, table: PlatformSystemRelationData.table);

    PlatformQuery.addFields(query);

    return query;
  }

  static Query selectAllSystemsByPlatformId(int id) {
    final Query query = FluentQuery
      .select()
      .from(SystemEntityData.table)
      .join(PlatformSystemRelationData.table, null, PlatformSystemRelationData.systemField, SystemEntityData.table, SystemEntityData.idField)
      .where(PlatformSystemRelationData.platformField, id, type: int, table: PlatformSystemRelationData.table);

    SystemQuery.addFields(query);

    return query;
  }

  static void _addIdWhere(int platformId, int systemId, Query query) {
    query.where(PlatformSystemRelationData.platformField, platformId, type: int, table: PlatformSystemRelationData.table);
    query.where(PlatformSystemRelationData.systemField, systemId, type: int, table: PlatformSystemRelationData.table);
  }
}