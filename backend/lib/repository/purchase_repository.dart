import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart' show DLCID, GameID, PurchaseEntity, PurchaseEntityData, PurchaseID, PurchaseTypeID, StoreID, PurchaseView;

import './query/query.dart' show PurchaseQuery, PurchaseTypeRelationQuery, GamePurchaseRelationQuery, DLCPurchaseRelationQuery;
import 'item_repository.dart';


class PurchaseRepository extends ItemRepository<PurchaseEntity, PurchaseID> {
  const PurchaseRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector, recordName: PurchaseEntityData.table);

  @override
  PurchaseEntity entityFromMap(Map<String, Object?> map) => PurchaseEntity.fromMap(map);
  @override
  PurchaseID idFromMap(Map<String, Object?> map) => PurchaseEntity.idFromMap(map);

  //#region CREATE
  @override
  Future<PurchaseEntity> create(PurchaseEntity entity) {

    final Query query = PurchaseQuery.create(entity);
    return createItem(
      query: query,
    );

  }

  Future<Object?> relatePurchaseType(PurchaseID purchaseId, PurchaseTypeID typeId) {

    final Query query = PurchaseTypeRelationQuery.create(purchaseId, typeId);
    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<PurchaseEntity> findById(PurchaseID id) {

    final Query query = PurchaseQuery.selectById(id);
    return readItem(
      query: query,
    );

  }

  @override
  Future<List<PurchaseEntity>> findAll([int? page]) {

    final Query query = PurchaseQuery.selectAll(page);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllWithView(PurchaseView purchaseView, [int? page]) {

    final Query query = PurchaseQuery.selectAllInView(purchaseView, null, page);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findFirstWithView(PurchaseView purchaseView, int limit) {

    final Query query = PurchaseQuery.selectFirstInView(purchaseView, limit);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllWithYearView(PurchaseView purchaseView, int year, [int? page]) {

    final Query query = PurchaseQuery.selectAllInView(purchaseView, year, page);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllFromGame(GameID id) {

    final Query query = GamePurchaseRelationQuery.selectAllPurchasesByGameId(id);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllFromStore(StoreID storeId) {

    final Query query = PurchaseQuery.selectAllByStore(storeId);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllFromDLC(DLCID id) {

    final Query query = DLCPurchaseRelationQuery.selectAllPurchasesByDLCId(id);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllFromPurchaseType(PurchaseTypeID id) {

    final Query query = PurchaseTypeRelationQuery.selectAllPurchasesByTypeId(id);
    return readItemList(
      query: query,
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<PurchaseEntity> update(PurchaseEntity entity, PurchaseEntity updatedEntity) {

    final PurchaseID id = entity.createId();
    final Query query = PurchaseQuery.updateById(id, entity, updatedEntity);
    return updateItem(
      query: query,
      id: id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<Object?> deleteById(PurchaseID id) {

    final Query query = PurchaseQuery.deleteById(id);
    return itemConnector.execute(query);

  }

  Future<Object?> unrelatePurchaseType(PurchaseID purchaseId, PurchaseTypeID typeId) {

    final Query query = PurchaseTypeRelationQuery.deleteById(purchaseId, typeId);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<PurchaseEntity>> findFirstByDescription(String description, int limit) {

    final Query query = PurchaseQuery.selectFirstByDescriptionLike(description, limit);
    return readItemList(
      query: query,
    );

  }
  //#endregion SEARCH
}