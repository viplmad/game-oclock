import 'dart:async';

import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import 'item_search.dart';


abstract class ItemRemoteSearchBloc<T extends Item, R extends ItemRepository<T>> extends ItemSearchBloc<T> {
  ItemRemoteSearchBloc({
    required this.repository,
  }) : super();

  final R repository;

  @override
  Stream<ItemSearchState> mapEventToState(ItemSearchEvent event) async* {

    yield* checkConnection();

    yield* super.mapEventToState(event);

  }

  Stream<ItemSearchState> checkConnection() async* {

    if(repository.isClosed()) {
      yield const ItemSearchError('Connection lost. Trying to reconnect');

      try {

        repository.reconnect();
        await repository.open();

      } catch(e) {

        yield ItemSearchError(e.toString());

      }
    }

  }
}