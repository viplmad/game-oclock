import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show SearchResultDTO, PrimaryModel;

import 'package:backend/service/service.dart' show SearchService;

import 'item_search.dart';

abstract class ItemSearchBloc<T extends PrimaryModel, S extends SearchService<T>>
    extends Bloc<ItemSearchEvent, ItemSearchState> {
  ItemSearchBloc({
    required this.service,
    required this.initialViewIndex,
  }) : super(ItemSearchEmpty<T>()) {
    on<SearchTextChanged>(_mapTextChangedToState);
  }

  final S service;
  final int initialViewIndex;

  final int maxSuggestions = 10;
  final int maxResults = 20;

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
        final SearchResultDTO<T> initialItems = await _getInitialItems();
        emit(
          ItemSearchEmpty<T>(initialItems.data),
        );
      } else {
        final SearchResultDTO<T> items = await _getSearchItems(query);
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

  Future<SearchResultDTO<T>> _getInitialItems() {
    return service.getAll(initialViewIndex, size: maxSuggestions);
  }

  Future<SearchResultDTO<T>> _getSearchItems(String query) {
    return service.searchAll(quicksearch: query, size: maxResults);
  }
}
