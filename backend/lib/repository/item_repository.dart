import 'package:meta/meta.dart';
import 'package:query/query.dart' show Query;

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/connector/connector.dart'
    show ItemConnector, ImageConnector;

import 'package:backend/utils/empty_result_set_exception.dart';

import 'repository_utils.dart';
import 'base_repository.dart';

abstract class ItemRepository<T extends ItemEntity, ID extends Object>
    extends BaseRepository {
  const ItemRepository(
    ItemConnector itemConnector,
    this.imageConnector, {
    required String recordName,
  }) : super(itemConnector, recordName: recordName);

  static const String _errorCreation = 'Error during creation';
  static const String _errorImageConnectorNotSet = 'Image connection not set';

  final ImageConnector? imageConnector;

  T entityFromMap(Map<String, Object?> map);
  ID idFromMap(Map<String, Object?> map);

  Future<T> create(T entity);
  Future<T> findById(ID id);
  Future<List<T>> findAll();
  Future<T> update(T entity, T updatedEntity);
  Future<Object?> deleteById(ID id);

  @nonVirtual
  String? getImageURI(String? imageName) {
    return imageName != null && imageConnector != null
        ? imageConnector!.getURI(
            tableName: recordName,
            imageFilename: imageName,
          )
        : null;
  }

  // Utils
  @nonVirtual
  Future<T> createItem({required Query query}) async {
    final ID? id =
        await itemConnector.execute(query).asStream().map(_listMapToID).first;

    if (id != null) {
      return findById(id);
    } else {
      return Future<T>.error(_errorCreation);
    }
  }

  @nonVirtual
  Future<T> readItem({required Query query}) {
    return itemConnector.execute(query).asStream().map(_listMapToSingle).first;
  }

  @nonVirtual
  Future<T?> readItemNullable({required Query query}) {
    return itemConnector
        .execute(query)
        .asStream()
        .map(_listMapToSingleNullable)
        .first;
  }

  @nonVirtual
  Future<List<T>> readItemList({required Query query}) {
    return itemConnector.execute(query).asStream().map(_listMapToList).first;
  }

  @nonVirtual
  Future<T> updateItem({required Query query, required ID id}) async {
    await itemConnector.execute(query);
    return findById(id);
  }

  @nonVirtual
  Future<T> setItemImage({
    required String uploadImagePath,
    required String initialImageName,
    required String? oldImageName,
    required Query Function(ID, String?) queryBuilder,
    required ID id,
  }) async {
    if (imageConnector == null) {
      return Future<T>.error(_errorImageConnectorNotSet);
    }

    if (oldImageName != null) {
      await imageConnector!.delete(
        tableName: recordName,
        imageName: oldImageName,
      );
    }

    final String imageName = await imageConnector!.set(
      imagePath: uploadImagePath,
      tableName: recordName,
      imageName: _getImageName(id, initialImageName),
    );

    return updateItem(
      query: queryBuilder(id, imageName),
      id: id,
    );
  }

  @nonVirtual
  Future<T> renameItemImage({
    required String oldImageName,
    required String newImageName,
    required Query Function(ID, String?) queryBuilder,
    required ID id,
  }) async {
    if (imageConnector == null) {
      return Future<T>.error(_errorImageConnectorNotSet);
    }

    final String imageName = await imageConnector!.rename(
      tableName: recordName,
      oldImageName: oldImageName,
      newImageName: _getImageName(id, newImageName),
    );

    return updateItem(
      query: queryBuilder(id, imageName),
      id: id,
    );
  }

  @nonVirtual
  Future<T> deleteItemImage({
    required String imageName,
    required Query Function(ID, String?) queryBuilder,
    required ID id,
  }) async {
    if (imageConnector == null) {
      return Future<T>.error(_errorImageConnectorNotSet);
    }

    await imageConnector!.delete(
      tableName: recordName,
      imageName: imageName,
    );

    return updateItem(
      query: queryBuilder(id, null),
      id: id,
    );
  }

  String _getImageName(ID id, String imageName) {
    return '$id-$imageName';
  }

  // Mapper
  List<T> _listMapToList(List<Map<String, Map<String, Object?>>> results) {
    final List<T> entities = <T>[];

    for (final Map<String, Map<String, Object?>> manyMap in results) {
      final Map<String, Object?> map =
          RepositoryUtils.combineMaps(manyMap, recordName);
      final T entity = entityFromMap(map);

      entities.add(entity);
    }

    return entities;
  }

  T _listMapToSingle(List<Map<String, Map<String, Object?>>> results) {
    if (results.isEmpty) {
      throw EmptyResultSetException('Result set is empty');
    }

    return _listMapToList(results).first;
  }

  T? _listMapToSingleNullable(List<Map<String, Map<String, Object?>>> results) {
    if (results.isEmpty) {
      return null;
    }

    return _listMapToSingle(results);
  }

  ID? _listMapToID(List<Map<String, Map<String, Object?>>> results) {
    ID? id;

    if (results.isNotEmpty) {
      final Map<String, Object?> map =
          RepositoryUtils.combineMaps(results.first, recordName);
      id = idFromMap(map);
    }

    return id;
  }
}
