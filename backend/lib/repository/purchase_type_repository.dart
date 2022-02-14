import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart'
    show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart'
    show
        PurchaseID,
        PurchaseTypeEntity,
        PurchaseTypeEntityData,
        PurchaseTypeID,
        PurchaseTypeView;

import './query/query.dart' show PurchaseTypeQuery, PurchaseTypeRelationQuery;
import 'item_repository.dart';

class PurchaseTypeRepository
    extends ItemRepository<PurchaseTypeEntity, PurchaseTypeID> {
  const PurchaseTypeRepository(
    ItemConnector itemConnector,
    ImageConnector? imageConnector,
  ) : super(
          itemConnector,
          imageConnector,
          recordName: PurchaseTypeEntityData.table,
        );

  @override
  PurchaseTypeEntity entityFromMap(Map<String, Object?> map) =>
      PurchaseTypeEntity.fromMap(map);
  @override
  PurchaseTypeID idFromMap(Map<String, Object?> map) =>
      PurchaseTypeEntity.idFromMap(map);

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
  Future<List<PurchaseTypeEntity>> findAll([int? page]) {
    final Query query = PurchaseTypeQuery.selectAll(page);
    return readItemList(
      query: query,
    );
  }

  Future<List<PurchaseTypeEntity>> findAllWithView(
    PurchaseTypeView typeView, [
    int? page,
  ]) {
    final Query query = PurchaseTypeQuery.selectAllInView(typeView, page);
    return readItemList(
      query: query,
    );
  }

  Future<List<PurchaseTypeEntity>> findFirstWithView(
    PurchaseTypeView typeView,
    int limit,
  ) {
    final Query query = PurchaseTypeQuery.selectFirstInView(typeView, limit);
    return readItemList(
      query: query,
    );
  }

  Future<List<PurchaseTypeEntity>> findAllFromPurchase(PurchaseID id) {
    final Query query =
        PurchaseTypeRelationQuery.selectAllTypesByPurchaseId(id);
    return readItemList(
      query: query,
    );
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<PurchaseTypeEntity> update(
    PurchaseTypeEntity entity,
    PurchaseTypeEntity updatedEntity,
  ) {
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
  Future<Object?> deleteById(PurchaseTypeID id) {
    final Query query = PurchaseTypeQuery.deleteById(id);
    return itemConnector.execute(query);
  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<PurchaseTypeEntity>> findFirstByName(String name, int limit) {
    final Query query = PurchaseTypeQuery.selectFirstByNameLike(name, limit);
    return readItemList(
      query: query,
    );
  }

  Future<List<PurchaseTypeEntity>> findFirstWithViewByName(
    PurchaseTypeView view,
    String name,
    int limit,
  ) {
    final Query query =
        PurchaseTypeQuery.selectFirstInViewByNameLike(view, name, limit);
    return readItemList(
      query: query,
    );
  }
  //#endregion SEARCH
}
