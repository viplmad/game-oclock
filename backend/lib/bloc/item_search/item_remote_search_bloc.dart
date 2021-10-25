import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import 'item_search.dart';


abstract class ItemRemoteSearchBloc<T extends Item, E extends ItemEntity, ID extends Object, R extends ItemRepository<E, ID>> extends ItemSearchBloc<T> {
  ItemRemoteSearchBloc({
    required this.repository,
  }) : super();

  final R repository;

  void _checkConnection(Emitter<ItemSearchState> emit) async {

    if(repository.isClosed()) {
      emit(
        const ItemSearchError('Connection lost. Trying to reconnect'),
      );

      try {

        repository.reconnect();
        await repository.open();

      } catch(e) {

        emit(
          ItemSearchError(e.toString()),
        );

      }
    }

  }

  @override
  void mapTextChangedToState(SearchTextChanged event, Emitter<ItemSearchState> emit) async {

    _checkConnection(emit);

    super.mapTextChangedToState(event, emit);

  }
}