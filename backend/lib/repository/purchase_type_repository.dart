import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart' show PurchaseID, PurchaseTypeEntity, PurchaseTypeEntityData, PurchaseTypeID, TypeView;

import './query/query.dart' show PurchaseTypeQuery, PurchaseTypeRelationQuery;
import 'item_repository.dart';


class PurchaseTypeRepository extends ItemRepository<PurchaseTypeEntity, PurchaseTypeID> {
  const PurchaseTypeRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  @override
  final String recordName = PurchaseTypeEntityData.table;
  @override
  PurchaseTypeEntity entityFromMap(Map<String, Object?> map) => PurchaseTypeEntity.fromMap(map);
  @override
  PurchaseTypeID idFromMap(Map<String, Object?> map) => PurchaseTypeEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<PurchaseTypeEntity> create(PurchaseTypeEntity entity) {

    final Query query = PurchaseTypeQuery.create(entity);
    return createItem(
      query: query,
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<PurchaseTypeEntity> findById(PurchaseTypeID id) {

    final Query query = PurchaseTypeQuery.selectById(id);
    return readItem(
      query: query,
    );

  }

  @override
  Future<List<PurchaseTypeEntity>> findAll() {

    final Query query = PurchaseTypeQuery.selectAll();
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseTypeEntity>> findAllPurchaseTypesWithView(TypeView typeView, [int? limit]) {

    final Query query = PurchaseTypeQuery.selectAllInView(typeView, limit);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseTypeEntity>> findAllPurchaseTypesFromPurchase(PurchaseID id) {

    final Query query = PurchaseTypeRelationQuery.selectAllTypesByPurchaseId(id);
    return readItemList(
      query: query,
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<PurchaseTypeEntity> update(PurchaseTypeEntity entity, PurchaseTypeEntity updatedEntity) {

    final PurchaseTypeID id = entity.createId();
    final Query query = PurchaseTypeQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(PurchaseTypeID id) {

    final Query query = PurchaseTypeQuery.deleteById(id);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<PurchaseTypeEntity>> findAllPurchaseTypesByName(String name, int limit) {

    final Query query = PurchaseTypeQuery.selectAllByNameLike(name, limit);
    return readItemList(
      query: query,
    );

  }
  //#endregion SEARCH
}