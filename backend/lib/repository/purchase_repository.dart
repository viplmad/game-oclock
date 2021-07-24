import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/entity/entity.dart' show DLCID, GameID, PurchaseEntity, PurchaseEntityData, PurchaseID, PurchaseTypeID, StoreID, PurchaseView;

import './query/query.dart' show PurchaseQuery, PurchaseTypeRelationQuery, GamePurchaseRelationQuery, DLCPurchaseRelationQuery;
import 'item_repository.dart';


class PurchaseRepository extends ItemRepository<PurchaseEntity, PurchaseID> {
  const PurchaseRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  @override
  final String recordName = PurchaseEntityData.table;
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

  Future<dynamic> relatePurchaseType(PurchaseID purchaseId, PurchaseTypeID typeId) {

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
  Future<List<PurchaseEntity>> findAll() {

    final Query query = PurchaseQuery.selectAll();
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllPurchasesWithView(PurchaseView purchaseView, [int? limit]) {

    final Query query = PurchaseQuery.selectAllInView(purchaseView, limit);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllPurchasesWithYearView(PurchaseView purchaseView, int year, [int? limit]) {

    final Query query = PurchaseQuery.selectAllInView(purchaseView, limit, year);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllPurchasesFromGame(GameID id) {

    final Query query = GamePurchaseRelationQuery.selectAllPurchasesByGameId(id);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllPurchasesFromStore(StoreID storeId) {

    final Query query = PurchaseQuery.selectAllByStore(storeId);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllPurchasesFromDLC(DLCID id) {

    final Query query = DLCPurchaseRelationQuery.selectAllPurchasesByDLCId(id);
    return readItemList(
      query: query,
    );

  }

  Future<List<PurchaseEntity>> findAllPurchasesFromPurchaseType(PurchaseTypeID id) {

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
  Future<dynamic> deleteById(PurchaseID id) {

    final Query query = PurchaseQuery.deleteById(id);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelatePurchaseType(PurchaseID purchaseId, PurchaseTypeID typeId) {

    final Query query = PurchaseTypeRelationQuery.deleteById(purchaseId, typeId);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Future<List<PurchaseEntity>> findAllPurchasesByDescription(String description, int limit) {

    final Query query = PurchaseQuery.selectAllByDescriptionLike(description, limit);
    return readItemList(
      query: query,
    );

  }
  //#endregion SEARCH
}