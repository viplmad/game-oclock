import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart' show Item;

import 'item_search.dart';

abstract class ItemSearchBloc<T extends Item>
    extends Bloc<ItemSearchEvent, ItemSearchState> {
  ItemSearchBloc() : super(ItemSearchEmpty<T>()) {
    on<SearchTextChanged>(mapTextChangedToState);
  }

  final int maxSuggestions = 10;
  final int maxResults = 20;

  @protected
  Future<void> mapTextChangedToState(
    SearchTextChanged event,
    Emitter<ItemSearchState> emit,
  ) async {
    emit(
      ItemSearchLoading(),
    );

    try {
      final String query = event.query;
      if (query.isEmpty) {
        final List<T> initialItems = await getInitialItems();
        emit(
          ItemSearchEmpty<T>(initialItems),
        );
      } else {
        final List<T> items = await getSearchItems(query);
        emit(
          ItemSearchSuccess<T>(items),
        );
      }
    } catch (e) {
      emit(
        ItemSearchError(e.toString()),
      );
    }
  }

  @protected
  Future<List<T>> getInitialItems();
  @protected
  Future<List<T>> getSearchItems(String query);
}
