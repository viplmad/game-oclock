import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show PurchaseTypeMapper;
import 'package:backend/entity/entity.dart' show PurchaseTypeEntity;
import 'package:backend/model/model.dart' show PurchaseType, TypeView;

import './query/query.dart' show PurchaseTypeQuery, PurchaseTypeRelationQuery;
import 'item_repository.dart';


class PurchaseTypeRepository extends ItemRepository<PurchaseType> {
  const PurchaseTypeRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  //#region CREATE
  @override
  Future<PurchaseType?> create(PurchaseType item) {

    final PurchaseTypeEntity entity = PurchaseTypeMapper.modelToEntity(item);
    final Query query = PurchaseTypeQuery.create(entity);

    return createCollectionItem(
      query: query,
      dynamicToId: PurchaseTypeEntity.idFromDynamicMap,
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Stream<PurchaseType?> findById(int id) {

    final Query query = PurchaseTypeQuery.selectById(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToSingle );

  }

  @override
  Stream<List<PurchaseType>> findAll() {

    return findAllPurchaseTypesWithView(TypeView.Main);

  }

  Stream<List<PurchaseType>> findAllPurchaseTypesWithView(TypeView typeView, [int? limit]) {

    final Query query = PurchaseTypeQuery.selectAllInView(typeView, limit);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }

  Stream<List<PurchaseType>> findAllPurchaseTypesFromPurchase(int id) {

    final Query query = PurchaseTypeRelationQuery.selectAllTypesByPurchaseId(id);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<PurchaseType?> update(PurchaseType item, PurchaseType updatedItem) {

    final PurchaseTypeEntity entity = PurchaseTypeMapper.modelToEntity(item);
    final PurchaseTypeEntity updatedEntity = PurchaseTypeMapper.modelToEntity(updatedItem);
    final Query query = PurchaseTypeQuery.updateById(item.id, entity, updatedEntity);

    return updateCollectionItem(
      query: query,
      id: item.id,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteById(int id) {

    final Query query = PurchaseTypeQuery.deleteById(id);
    return itemConnector.execute(query);

  }
  //#endregion DELETE

  //#region SEARCH
  Stream<List<PurchaseType>> findAllPurchaseTypesByName(String name, int maxResults) {

    final Query query = PurchaseTypeQuery.selectAllByNameLike(name, maxResults);
    return itemConnector.execute(query)
      .asStream().map( dynamicToList );

  }
  //#endregion SEARCH

  @override
  List<PurchaseType> dynamicToList(List<Map<String, Map<String, dynamic>>> results) {

    return PurchaseTypeEntity.fromDynamicMapList(results).map( PurchaseTypeMapper.entityToModel ).toList(growable: false);

  }
}