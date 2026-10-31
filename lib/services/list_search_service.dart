import 'dart:convert';
import 'dart:math';

import 'package:game_oclock/models/models.dart'
    show
        GameOClockException,
        ListSearch,
        errorCodeAlreadyExists,
        errorCodeNotFound;

import 'shared_preferences_repository.dart';

class ListSearchService {
  const ListSearchService(this.repository);

  final SharedPreferencesRepository repository;

  Future<List<String>> _getIds(String space) => repository
      .get(_buildIdsKey(space), (value) {
        return (json.decode(value) as List).cast<String>();
      })
      .then((value) => List.unmodifiable(value));

  Future<void> _setIds(String space, List<String> keys) =>
      repository.set(_buildIdsKey(space), keys, (value) => json.encode(value));

  Future<List<ListSearch>> getAll(String space) async {
    final ids = await _getIds(space);

    final result = <ListSearch>[];
    for (final id in ids) {
      final listSearch = await get(space, id);
      result.add(listSearch);
    }
    return result;
  }

  Future<String> getCurrentKey(String space) {
    return repository.getString(_buildCurrentKey(space));
  }

  Future<void> saveCurrent(String space, ListSearch search) {
    final id = search.id;
    return repository.setString(_buildCurrentKey(space), id);
  }

  Future<void> removeCurrent(String space) {
    return repository.remove(_buildCurrentKey(space));
  }

  Future<ListSearch> get(String space, String id) {
    return repository.get(
      _buildElementKey(space, id),
      (value) => ListSearch.fromJson(json.decode(value)),
    );
  }

  Future<String> create(String space, ListSearch search) async {
    final id = 'user-${Random().nextInt(100)}';
    if (await exists(space, id)) {
      throw GameOClockException(
        code: errorCodeAlreadyExists,
        message: 'ListSearch with id $id already exists',
      );
    }

    final createdListSearch = ListSearch.manual(
      id: id,
      name: search.name,
      filter: search.filter,
      sort: search.sort,
    );
    await repository.set(
      _buildElementKey(space, id),
      createdListSearch,
      (value) => json.encode(value.toJson()),
    );

    final ids = await _getIds(space);
    await _setIds(space, [...ids, id]);
    return id;
  }

  Future<void> update(String space, ListSearch search) async {
    final id = search.id;
    if (!await exists(space, id)) {
      throw GameOClockException(
        code: errorCodeNotFound,
        message: 'ListSearch with id $id not found',
      );
    }

    return repository.set(
      _buildElementKey(space, id),
      search,
      (value) => json.encode(value.toJson()),
    );
  }

  Future<void> delete(String space, String id) async {
    await repository.remove(_buildElementKey(space, id));

    final ids = await _getIds(space);
    return _setIds(
      space,
      ids.takeWhile((el) => el != id).toList(growable: false),
    );
  }

  Future<bool> exists(String space, String id) async =>
      repository.exists(_buildElementKey(space, id));

  String _buildKey(String space) => 'list-search#$space';
  String _buildCurrentKey(String space) => '${_buildKey(space)}#current';
  String _buildIdsKey(String space) => '${_buildKey(space)}#ids';
  String _buildElementKey(String space, String id) =>
      '${_buildKey(space)}#el-$id';
}
