import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import '../bloc_utils.dart';
import 'item_list_manager.dart';

abstract class ItemListManagerBloc<T extends Item, E extends ItemEntity,
        ID extends Object, R extends ItemRepository<E, ID>>
    extends Bloc<ItemListManagerEvent, ItemListManagerState> {
  ItemListManagerBloc({
    required this.repository,
  }) : super(ItemListManagerInitialised()) {
    on<AddItem<T>>(_mapAddItemToState);
    on<DeleteItem<T>>(_mapDeleteItemToState);
  }

  final R repository;

  Future<void> _checkConnection(Emitter<ItemListManagerState> emit) async {
    await BlocUtils.checkConnection<ItemListManagerState, ItemNotAdded>(
      repository,
      emit,
      (final String error) => ItemNotAdded(error),
    );
  }

  void _mapAddItemToState(
    AddItem<T> event,
    Emitter<ItemListManagerState> emit,
  ) async {
    await _checkConnection(emit);

    try {
      final T item = await create(event);
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
    await _checkConnection(emit);

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

  @protected
  Future<T> create(AddItem<T> event);
  @protected
  Future<Object?> delete(DeleteItem<T> event);
}
