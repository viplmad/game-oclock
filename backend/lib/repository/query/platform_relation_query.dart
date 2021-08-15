import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show PlatformEntityData, PlatformID, PlatformSystemRelationData, SystemID, SystemEntityData;

import 'query.dart' show PlatformQuery, SystemQuery;


class PlatformSystemRelationQuery {
  PlatformSystemRelationQuery._();

  static Query create(PlatformID platformId, SystemID systemId) {
    final Query query = FluentQuery
      .insert()
      .into(PlatformSystemRelationData.table)
      .set(PlatformSystemRelationData.platformField, platformId.id)
      .set(PlatformSystemRelationData.systemField, systemId.id);

    return query;
  }

  static Query deleteById(PlatformID platformId, SystemID systemId) {
    final Query query = FluentQuery
      .delete()
      .from(PlatformSystemRelationData.table);

    _addIdWhere(platformId, systemId, query);

    return query;
  }

  static Query selectAllPlatformsBySystemId(SystemID id) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table)
      .join(PlatformSystemRelationData.table, null, PlatformSystemRelationData.platformField, PlatformEntityData.table, PlatformEntityData.idField)
      .where(PlatformSystemRelationData.systemField, id.id, type: int, table: PlatformSystemRelationData.table);

    PlatformQuery.addFields(query);

    return query;
  }

  static Query selectAllSystemsByPlatformId(PlatformID id) {
    final Query query = FluentQuery
      .select()
      .from(SystemEntityData.table)
      .join(PlatformSystemRelationData.table, null, PlatformSystemRelationData.systemField, SystemEntityData.table, SystemEntityData.idField)
      .where(PlatformSystemRelationData.platformField, id.id, type: int, table: PlatformSystemRelationData.table);

    SystemQuery.addFields(query);

    return query;
  }

  static void _addIdWhere(PlatformID platformId, SystemID systemId, Query query) {
    query.where(PlatformSystemRelationData.platformField, platformId.id, type: int, table: PlatformSystemRelationData.table);
    query.where(PlatformSystemRelationData.systemField, systemId.id, type: int, table: PlatformSystemRelationData.table);
  }
}