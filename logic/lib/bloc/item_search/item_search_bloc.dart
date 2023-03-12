import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart'
    show PageResultDTO, PrimaryModel;

import 'package:logic/service/service.dart' show SearchService;

import 'item_search.dart';

abstract class ItemSearchBloc<T extends PrimaryModel,
    S extends SearchService<T>> extends Bloc<ItemSearchEvent, ItemSearchState> {
  ItemSearchBloc({
    required this.service,
  }) : super(ItemSearchEmpty<T>()) {
    on<SearchTextChanged>(_mapTextChangedToState);
  }

  final S service;

  final int _maxSuggestions = 10;
  final int _maxResults = 20;

  Future<void> _mapTextChangedToState(
    SearchTextChanged event,
    Emitter<ItemSearchState> emit,
  ) async {
    emit(
      ItemSearchLoading(),
    );

    try {
      final String query = event.query;
      if (query.isEmpty) {
        final PageResultDTO<T> initialItems = await _getInitialItems();
        emit(
          ItemSearchEmpty<T>(initialItems.data),
        );
      } else {
        final PageResultDTO<T> items = await _getSearchItems(query);
        emit(
          ItemSearchSuccess<T>(items.data),
        );
      }
    } catch (e) {
      emit(
        ItemSearchError(e.toString()),
      );
    }
  }

  Future<PageResultDTO<T>> _getInitialItems() {
    return service.getLastUpdated(size: _maxSuggestions);
  }

  Future<PageResultDTO<T>> _getSearchItems(String query) {
    return service.searchAll(quicksearch: query, size: _maxResults);
  }
}