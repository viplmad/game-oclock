import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';


class ItemSearchBloc extends Bloc<ItemSearchEvent, ItemSearchState> {

  ItemSearchBloc({@required this.collectionRepository, @required this.tableSearch});

  final ICollectionRepository collectionRepository;
  final String tableSearch;

  final int _maxResults = 10;

  @override
  ItemSearchState get initialState => ItemSearchEmpty();

  @override
  Stream<ItemSearchState> mapEventToState(ItemSearchEvent event) async* {

    if(event is SearchTextChanged) {

      yield* _mapTextChangedToState(event);

    }

  }

  Stream<ItemSearchState> _mapTextChangedToState(SearchTextChanged event) async* {

    yield ItemSearchLoading();

    try {

      final query = event.query;
      if(query.isEmpty) {

        yield ItemSearchEmpty();

      } else {

        final List<CollectionItem> items = await collectionRepository.getSearchStream(tableSearch, query, _maxResults).first;

        yield ItemSearchSuccess(items);

      }

    } catch(e) {

      yield ItemSearchError(e.toString());

    }

  }

  @override
  Future<void> close() {

    return super.close();

  }

}