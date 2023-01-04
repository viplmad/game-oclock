import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'package:backend/service/service.dart' show ItemService;

import 'item_list_manager.dart';

abstract class ItemListManagerBloc<T extends PrimaryModel, N extends Object,
        S extends ItemService<T, N>>
    extends Bloc<ItemListManagerEvent, ItemListManagerState> {
  ItemListManagerBloc({
    required this.service,
  }) : super(ItemListManagerInitialised()) {
    on<AddItem<N>>(_mapAddItemToState);
    on<DeleteItem<T>>(_mapDeleteItemToState);
  }

  final S service;

  void _mapAddItemToState(
    AddItem<N> event,
    Emitter<ItemListManagerState> emit,
  ) async {
    try {
      final T item = await _create(event);
      emit(
        ItemAdded<T>(item),
      );
    } catch (e) {
      emit(
        ItemNotAdded(e.toString()),
      );
    }

    emit(
      ItemListManagerInitialised(),
    );
  }

  void _mapDeleteItemToState(
    DeleteItem<T> event,
    Emitter<ItemListManagerState> emit,
  ) async {
    try {
      await delete(event);
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

  Future<T> _create(AddItem<N> event) {
    return service.create(event.item);
  }

  Future<void> delete(DeleteItem<T> event) {
    return service.delete(event.item.id);
  }
}
