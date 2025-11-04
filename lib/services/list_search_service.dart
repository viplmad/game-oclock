import 'dart:convert';

import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;

import 'shared_preferences_repository.dart';

class ListSearchService {
  const ListSearchService(this.repository);

  final SharedPreferencesRepository repository;

  Future<List<ListSearch>> getAll(final String space) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(5, (final index) {
      final finalIndex = index;
      return mockSearch(
        name: 'search $space $finalIndex',
        filters: 2,
        sorts: 1,
      );
    });
  }

  Future<ListSearch?> getCurrent(final String space) async {
    return repository.get(
      _buildKey(space),
      (final value) => ListSearch.fromJson(json.decode(value)),
    );
  }

  Future<void> saveCurrent(final String space, final ListSearch search) {
    return repository.set(
      _buildKey(space),
      search,
      (final value) => json.encode(search.toJson()),
    );
  }

  Future<ListSearch> get(final String space, final String name) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockSearch(name: space + name, filters: 3);
  }

  Future<ListSearch> create(final String space, final ListSearch search) async {
    await Future.delayed(const Duration(seconds: 1));
    return search;
  }

  Future<void> update(final String space, final ListSearch search) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  String _buildKey(final String space) => 'list-search#$space';
}
