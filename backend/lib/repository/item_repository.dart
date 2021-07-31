import 'package:meta/meta.dart';
import 'package:query/query.dart' show Query;

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;

import 'package:backend/utils/empty_result_set_exception.dart';


abstract class ItemRepository<T extends ItemEntity, ID extends Object> {
  const ItemRepository(this.itemConnector, this.imageConnector);

  final ItemConnector itemConnector;
  final ImageConnector imageConnector;

  Future<Object?> open() => itemConnector.open();
  Future<Object?> close() => itemConnector.close();

  bool isOpen() => itemConnector.isOpen();
  bool isClosed() => itemConnector.isClosed();

  void reconnect() => itemConnector.reconnect();

  String get recordName;
  T entityFromMap(Map<String, Object?> map);
  ID idFromMap(Map<String, Object?> map);

  Future<T> create(T entity);
  Future<T> findById(ID id);
  Future<List<T>> findAll();
  Future<T> update(T entity, T updatedEntity);
  Future<Object?> deleteById(ID id);

  String? getImageURI(String? imageName) {

    return imageName != null?
        imageConnector.getURI(
          tableName: recordName,
          imageFilename: imageName,
        )
        : null;

  }

  // Utils
  @protected
  Future<T> createItem({required Query query}) async {

    final ID? id = await itemConnector.execute(query)
      .asStream()
      .map( _listMapToID ).first;

    if(id != null) {
      return findById(id);
    } else {
      return Future<T>.error('Error during creation');
    }

  }

  @protected
  Future<T> readItem({required Query query}) {

    return itemConnector.execute(query)
      .asStream().map( _listMapToSingle ).first;

  }

  @protected
  Future<List<T>> readItemList({required Query query}) {

    return itemConnector.execute(query)
      .asStream().map( _listMapToList ).first;

  }

  @protected
  Future<T> updateItem({required Query query, required ID id}) async {

    await itemConnector.execute(query);
    return findById(id);

  }

  @protected
  Future<T> setItemImage({required String uploadImagePath, required String initialImageName, required String? oldImageName, required Query Function(ID, String?) queryBuilder, required ID id}) async {

    if(oldImageName != null) {
      await imageConnector.delete(
        tableName: recordName,
        imageName: oldImageName,
      );
    }

    final String imageName = await imageConnector.set(
      imagePath: uploadImagePath,
      tableName: recordName,
      imageName: _getImageName(id, initialImageName),
    );

    return updateItem(
      query: queryBuilder(id, imageName),
      id: id,
    );

  }

  @protected
  Future<T> renameItemImage({required String oldImageName, required String newImageName, required Query Function(ID, String?) queryBuilder, required ID id}) async {

    final String imageName = await imageConnector.rename(
      tableName: recordName,
      oldImageName: oldImageName,
      newImageName: _getImageName(id, newImageName),
    );

    return updateItem(
      query: queryBuilder(id, imageName),
      id: id,
    );

  }

  @protected
  Future<T> deleteItemImage({required String imageName, required Query Function(ID, String?) queryBuilder, required ID id}) async {

    await imageConnector.delete(
      tableName: recordName,
      imageName: imageName,
    );

    return updateItem(
      query: queryBuilder(id, null),
      id: id,
    );

  }

  String _getImageName(ID id, String imageName) {

    return id.toString() + '-' + imageName;

  }

  // Mapper
  List<T> _listMapToList(List<Map<String, Map<String, Object?>>> results) {
    final List<T> entities = <T>[];

    results.forEach( (Map<String, Map<String, Object?>> manyMap) {
      final Map<String, Object?> map = ItemRepositoryUtils.combineMaps(manyMap, recordName);
      final T entity = entityFromMap(map);

      entities.add(entity);
    });

    return entities;
  }

  T _listMapToSingle(List<Map<String, Map<String, Object?>>> results) {
    if(results.isEmpty) {
      throw EmptyResultSetException('Result set is empty');
    }

    return _listMapToList(results).first;
  }

  ID? _listMapToID(List<Map<String, Map<String, Object?>>> results) {
    ID? id;

    if(results.isEmpty) {
      final Map<String, Object?> map = ItemRepositoryUtils.combineMaps(results.first, recordName);
      id = idFromMap(map);
    }

    return id;
  }
}

class ItemRepositoryUtils {
  ItemRepositoryUtils._();

  static Map<String, Object?> combineMaps(Map<String, Map<String, Object?>> manyMap, String primaryTableName) {
    final Map<String, Object?> combinedMaps = Map<String, Object?>();

    manyMap.forEach((String table, Map<String, Object?> map) {

      if(table.isEmpty || table == primaryTableName) {
        combinedMaps.addAll( map );
      }

    });

    return combinedMaps;
  }
}