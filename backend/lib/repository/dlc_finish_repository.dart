import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart' show DLCFinishEntity, DLCFinishID, DLCID, DLCFinishEntityData;

import './query/query.dart' show DLCFinishQuery;
import 'item_repository.dart';


class DLCFinishRepository extends ItemRepository<DLCFinishEntity, DLCFinishID> {
  DLCFinishRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  @override
  final String recordName = DLCFinishEntityData.table;
  @override
  DLCFinishEntity entityFromMap(Map<String, Object?> map) => DLCFinishEntity.fromMap(map);
  @override
  DLCFinishID idFromMap(Map<String, Object?> map) => DLCFinishEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<DLCFinishEntity> create(DLCFinishEntity entity) {

    final Query query = DLCFinishQuery.create(entity);
    return createItem(
      query: query,
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<DLCFinishEntity> findById(DLCFinishID id) {

    final Query query = DLCFinishQuery.selectById(id);
    return readItem(
      query: query,
    );

  }

  @override
  Future<List<DLCFinishEntity>> findAll() {

    final Query query = DLCFinishQuery.selectAll();
    return readItemList(
      query: query,
    );

  }

  Future<List<DLCFinishEntity>> findAllDLCFinishFromDLC(DLCID id) {

    final Query query = DLCFinishQuery.selectAllByDLC(id);
    return readItemList(
      query: query,
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<DLCFinishEntity> update(DLCFinishEntity entity, DLCFinishEntity updatedEntity) {

    final DLCFinishID id = entity.createId();
    final Query query = DLCFinishQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(DLCFinishID id) {

    final Query query = DLCFinishQuery.deleteById(id);
    return itemConnector.execute(query);

  }
  //#region DELETE
}