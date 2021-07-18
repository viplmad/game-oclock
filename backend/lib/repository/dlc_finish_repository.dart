import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/mapper/mapper.dart' show DLCMapper;
import 'package:backend/entity/entity.dart' show DLCFinishEntity;
import 'package:backend/model/model.dart' show DLCFinish;

import './query/query.dart' show DLCFinishQuery;
import 'item_repository.dart';


class DLCFinishRepository extends ItemRepository<DLCFinish> {
  DLCFinishRepository(ItemConnector itemConnector, ImageConnector imageConnector) : super(itemConnector, imageConnector);

  //#region CREATE
  Future<dynamic> create(int dlcId, DLCFinish finish) {

    final DLCFinishEntity entity = DLCMapper.finishModelToEntity(finish);
    final Query query = DLCFinishQuery.create(entity, dlcId);

    return itemConnector.execute(query);

  }
  //#endregion CREATE

  //#region READ
  Stream<T?> findById(int id) {

  }
  Stream<List<T>> findAll();

  Stream<List<DLCFinish>> findAllDLCFinishFromDLC(int id) {

    final Query query = DLCFinishQuery.selectAllByDLC(id);
    return itemConnector.execute(query)
      .asStream().map( _dynamicToListDLCFinish );

  }
  //#endregion READ

  //#region DELETE
  Future<dynamic> deleteById(int dlcId, DateTime date) {

    final Query query = DLCFinishQuery.deleteById(dlcId, date);
    return itemConnector.execute(query);

  }
  //#region DELETE

  List<DLCFinish> dynamicToList(List<Map<String, Map<String, dynamic>>> results) {

    return DLCFinishEntity.fromDynamicMapList(results).map( DLCMapper.finishEntityToModel ).toList(growable: false);

  }
}