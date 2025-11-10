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

  Future<List<String>> _getIds(final String space) => repository
      .get(_buildIdsKey(space), (final value) {
        return (json.decode(value) as List).cast<String>();
      })
      .then((final value) => List.unmodifiable(value));

  Future<void> _setIds(final String space, final List<String> keys) =>
      repository.set(
        _buildIdsKey(space),
        keys,
        (final value) => json.encode(value),
      );

  Future<List<ListSearch>> getAll(final String space) async {
    final ids = await _getIds(space);

    final result = <ListSearch>[];
    for (final id in ids) {
      final listSearch = await get(space, id);
      result.add(listSearch);
    }
    return result;
  }

  Future<ListSearch> getCurrent(final String space) async {
    final currentKey = await repository.getString(_buildCurrentKey(space));
    return get(space, currentKey);
  }

  Future<void> saveCurrent(final String space, final ListSearch search) async {
    final id = search.id;
    if (!await exists(space, id)) {
      throw GameOClockException(
        code: errorCodeNotFound,
        message: 'ListSearch with id $id not found',
      );
    }

    return repository.setString(_buildCurrentKey(space), id);
  }

  Future<void> removeCurrent(final String space) {
    return repository.remove(_buildCurrentKey(space));
  }

  Future<ListSearch> get(final String space, final String id) {
    return repository.get(
      _buildElementKey(space, id),
      (final value) => ListSearch.fromJson(json.decode(value)),
    );
  }

  Future<ListSearch> create(final String space, final ListSearch search) async {
    final id = Random().nextInt(100).toString();
    if (await exists(space, id)) {
      throw GameOClockException(
        code: errorCodeAlreadyExists,
        message: 'ListSearch with id $id already exists',
      );
    }

    final createdListSearch = ListSearch(
      id: id,
      name: search.name,
      search: search.search,
    );
    await repository.set(
      _buildElementKey(space, id),
      createdListSearch,
      (final value) => json.encode(value.toJson()),
    );

    final ids = await _getIds(space);
    await _setIds(space, [...ids, id]);
    return createdListSearch;
  }

  Future<void> update(final String space, final ListSearch search) async {
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
      (final value) => json.encode(value.toJson()),
    );
  }

  Future<void> delete(final String space, final String id) async {
    await repository.remove(_buildElementKey(space, id));

    final ids = await _getIds(space);
    return _setIds(
      space,
      ids.takeWhile((final el) => el != id).toList(growable: false),
    );
  }

  Future<bool> exists(final String space, final String id) async =>
      repository.exists(_buildElementKey(space, id));

  String _buildKey(final String space) => 'list-search#$space';
  String _buildCurrentKey(final String space) => '${_buildKey(space)}#current';
  String _buildIdsKey(final String space) => '${_buildKey(space)}#ids';
  String _buildElementKey(final String space, final String id) =>
      '${_buildKey(space)}#el-$id';
}
