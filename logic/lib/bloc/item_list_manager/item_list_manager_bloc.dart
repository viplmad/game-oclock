import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode, PrimaryModel;

import 'package:logic/service/service.dart' show ItemService;
import 'package:logic/bloc/bloc_utils.dart';

import 'item_list_manager.dart';

abstract class ItemListManagerBloc<T extends PrimaryModel, N extends Object,
        S extends ItemService<T, N>>
    extends Bloc<ItemListManagerEvent, ItemListManagerState> {
  ItemListManagerBloc({
    required this.service,
  }) : super(ItemListManagerInitialised()) {
    on<AddItem<N>>(_mapAddItemToState);
    on<DeleteItem<T>>(_mapDeleteItemToState);
    on<WarnItemListNotLoaded>(_mapWarnNotLoadedToState);
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
      BlocUtils.handleError(
        e,
        emit,
        (ErrorCode error, String errorDescription) =>
            ItemNotAdded(error, errorDescription),
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
      await _delete(event);
      emit(
        ItemDeleted<T>(event.item),
      );
    } catch (e) {
      BlocUtils.handleError(
        e,
        emit,
        (ErrorCode error, String errorDescription) =>
            ItemNotDeleted(error, errorDescription),
      );
    }

    emit(
      ItemListManagerInitialised(),
    );
  }

  void _mapWarnNotLoadedToState(
    WarnItemListNotLoaded event,
    Emitter<ItemListManagerState> emit,
  ) {
    emit(ItemListNotLoaded(event.error, event.errorDescription));

    emit(
      ItemListManagerInitialised(),
    );
  }

  Future<T> _create(AddItem<N> event) {
    return service.create(event.item);
  }

  Future<void> _delete(DeleteItem<T> event) {
    return service.delete(event.item.id);
  }
}
