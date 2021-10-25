import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import 'item_list_manager.dart';


abstract class ItemListManagerBloc<T extends Item, E extends ItemEntity, ID extends Object, R extends ItemRepository<E, ID>> extends Bloc<ItemListManagerEvent, ItemListManagerState> {
  ItemListManagerBloc({
    required this.repository,
  }) : super(ItemListManagerInitialised()) {

    on<AddItem<T>>(_mapAddItemToState);
    on<DeleteItem<T>>(_mapDeleteItemToState);

  }

  final R repository;

  void _checkConnection(Emitter<ItemListManagerState> emit) async {

    if(repository.isClosed()) {

      try {

        repository.reconnect();
        await repository.open();

      } catch (e) {

        emit(
          ItemNotAdded(e.toString()),
        );

      }
    }

  }

  void _mapAddItemToState(AddItem<T> event, Emitter<ItemListManagerState> emit) async {

    _checkConnection(emit);

    try {

      final T? item = await createFuture(event);
      if(item != null) {
        emit(
          ItemAdded<T>(item),
        );
      } else {
        throw Exception();
      }

    } catch (e) {

      emit(
        ItemNotAdded(e.toString()),
      );

    }

    emit(
      ItemListManagerInitialised(),
    );

  }

  void _mapDeleteItemToState(DeleteItem<T> event, Emitter<ItemListManagerState> emit) async {

    _checkConnection(emit);

    try{

      await deleteFuture(event);
      emit(
        ItemDeleted<T>(event.item),
      );

    } catch (e) {

      emit(
        ItemNotDeleted(e.toString()),
      );

    }

    emit(
      ItemListManagerInitialised(),
    );

  }

  @protected
  Future<T> createFuture(AddItem<T> event);
  @protected
  Future<Object?> deleteFuture(DeleteItem<T> event);
}