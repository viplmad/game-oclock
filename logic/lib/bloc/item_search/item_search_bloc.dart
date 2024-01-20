import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart'
    show ErrorCode, PageResultDTO, PrimaryModel;

import 'package:logic/service/service.dart' show SearchService;
import 'package:logic/bloc/bloc_utils.dart';

import 'item_search.dart';

abstract class ItemSearchBloc<T extends PrimaryModel,
    S extends SearchService<T>> extends Bloc<ItemSearchEvent, ItemSearchState> {
  ItemSearchBloc({
    required this.service,
  }) : super(ItemSearchEmpty<T>()) {
    on<SearchTextChanged>(_mapTextChangedToState);
    on<ReloadItemSearch>(_mapReloadToState);
  }

  final S service;

  final int _maxSuggestions = 10;
  final int _maxResults = 20;

  void _mapTextChangedToState(
    SearchTextChanged event,
    Emitter<ItemSearchState> emit,
  ) async {
    emit(
      ItemSearchLoading(),
    );

    await _mapAnyLoadToState(event.query, emit);
  }

  void _mapReloadToState(
    ReloadItemSearch event,
    Emitter<ItemSearchState> emit,
  ) async {
    if (state is ItemSearchSuccess<T>) {
      final String query = (state as ItemSearchSuccess<T>).query;

      emit(
        ItemSearchLoading(),
      );

      await _mapAnyLoadToState(query, emit);
    } else if (state is ItemSearchError) {
      final String query = (state as ItemSearchError).query;

      emit(
        ItemSearchLoading(),
      );

      await _mapAnyLoadToState(query, emit);
    } else if (state is! ItemSearchLoading) {
      await _mapAnyLoadToState('', emit);
    }
  }

  Future<void> _mapAnyLoadToState(
    String query,
    Emitter<ItemSearchState> emit,
  ) async {
    try {
      if (query.isEmpty) {
        final PageResultDTO<T> initialItems = await _getInitialItems();
        emit(
          ItemSearchEmpty<T>(initialItems.data),
        );
      } else {
        final PageResultDTO<T> items = await _getSearchItems(query);
        emit(
          ItemSearchSuccess<T>(query, items.data),
        );
      }
    } catch (e) {
      _handleError(query, e, emit);
    }
  }

  void _handleError(String query, Object e, Emitter<ItemSearchState> emit) {
    BlocUtils.handleError(
      e,
      emit,
      (ErrorCode error, String errorDescription) =>
          ItemSearchError(query, error, errorDescription),
    );
  }

  Future<PageResultDTO<T>> _getInitialItems() {
    return service.getLastUpdated(size: _maxSuggestions);
  }

  Future<PageResultDTO<T>> _getSearchItems(String query) {
    return service.searchAll(quicksearch: query, size: _maxResults);
  }
}
