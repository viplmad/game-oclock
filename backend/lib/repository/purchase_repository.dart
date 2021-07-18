import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/entity/entity.dart' show PurchaseEntity;
import 'package:backend/model/model.dart' show Purchase, PurchaseView;

import './query/query.dart' show PurchaseQuery, PurchaseTypeRelationQuery, GamePurchaseRelationQuery, DLCPurchaseRelationQuery;
import 'item_repository.dart';


class PurchaseRepository extends ItemRepository<Purchase> {
  const PurchaseRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  //#region CREATE
  @override
  Future<Purchase?> create(Purchase item) {

    final PurchaseEntity entity = PurchaseMapper.modelToEntity(item);
    final Query query = PurchaseQuery.create(entity);

    return createCollectionItem(
      query: query,
      dynamicToId: PurchaseEntity.idFromDynamicMap,
    );

  }

  Future<dynamic> relatePurchaseType(int purchaseId, int typeId) {

    final Query query = PurchaseTypeRelationQuery.create(purchaseId, typeId);
    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  @override
  Stream<Purchase?> findById(int id) {

    final Query query = PurchaseQuery.selectById(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }

  @override
  Stream<List<Purchase>> findAll() {

    return findAllPurchasesWithView(PurchaseView.Main);

  }

  Stream<List<Purchase>> findAllPurchasesWithView(PurchaseView purchaseView, [int? limit]) {

    final Query query = PurchaseQuery.selectAllInView(purchaseView, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Purchase>> findAllPurchasesWithYearView(PurchaseView purchaseView, int year, [int? limit]) {

    final Query query = PurchaseQuery.selectAllInView(purchaseView, limit, year);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Purchase>> findAllPurchasesFromGame(int id) {

    final Query query = GamePurchaseRelationQuery.selectAllPurchasesByGameId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Purchase>> findAllPurchasesFromStore(int storeId) {

    final Query query = PurchaseQuery.selectAllByStore(storeId);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Purchase>> findAllPurchasesFromDLC(int id) {

    final Query query = DLCPurchaseRelationQuery.selectAllPurchasesByDLCId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<Purchase>> findAllPurchasesFromPurchaseType(int id) {

    final Query query = PurchaseTypeRelationQuery.selectAllPurchasesByTypeId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<Purchase?> update(Purchase item, Purchase updatedItem) {

    final PurchaseEntity entity = PurchaseMapper.modelToEntity(item);
    final PurchaseEntity updatedEntity = PurchaseMapper.modelToEntity(updatedItem);
    final Query query = PurchaseQuery.updateById(item.id, entity, updatedEntity);

    return updateCollectionItem(
      query: query,
      id: item.id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(int id) {

    final Query query = PurchaseQuery.deleteById(id);
    return itemConnector.execute(query);

  }

  Future<dynamic> unrelatePurchaseType(int purchaseId, int typeId) {

    final Query query = PurchaseTypeRelationQuery.deleteById(purchaseId, typeId);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Stream<List<Purchase>> findAllPurchasesByDescription(String description, int maxResults) {

    final Query query = PurchaseQuery.selectAllByDescriptionLike(description, maxResults);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion SEARCH

  @override
  List<Purchase> dynamicToList(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseEntity.fromDynamicMapList(results).map( PurchaseMapper.entityToModel ).toList(growable: false);

  }
}