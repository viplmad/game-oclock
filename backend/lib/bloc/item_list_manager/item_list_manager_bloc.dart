import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import 'item_list_manager.dart';


abstract class ItemListManagerBloc<T extends Item, E extends ItemEntity, ID extends Object, R extends ItemRepository<E, ID>> extends Bloc<ItemListManagerEvent, ItemListManagerState> {
  ItemListManagerBloc({
    required this.repository,
  }) : super(ItemListManagerInitialised());

  final R repository;

  @override
  Stream<ItemListManagerState> mapEventToState(ItemListManagerEvent event) async* {

    yield* _checkConnection();

    if(event is AddItem<T>) {

      yield* _mapAddItemToState(event);

    } else if(event is DeleteItem<T>) {

      yield* _mapDeleteItemToState(event);

    }

    yield ItemListManagerInitialised();

  }

  Stream<ItemListManagerState> _checkConnection() async* {

    if(repository.isClosed()) {

      try {

        repository.reconnect();
        await repository.open();

      } catch (e) {

        yield ItemNotAdded(e.toString());

      }
    }

  }

  Stream<ItemListManagerState> _mapAddItemToState(AddItem<T> event) async* {

    try {

      final T? item = await createFuture(event);
      if(item != null) {
        yield ItemAdded<T>(item);
      } else {
        throw Exception();
      }

    } catch (e) {

      yield ItemNotAdded(e.toString());

    }

  }

  Stream<ItemListManagerState> _mapDeleteItemToState(DeleteItem<T> event) async* {

    try{

      await deleteFuture(event);
      yield ItemDeleted<T>(event.item);

    } catch (e) {

      yield ItemNotDeleted(e.toString());

    }

  }

  Future<T> createFuture(AddItem<T> event);
  Future<Object?> deleteFuture(DeleteItem<T> event);
}