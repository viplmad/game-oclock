import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'package:backend/service/service.dart' show ItemService;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';

abstract class ItemDetailBloc<T extends PrimaryModel, N extends Object,
        S extends ItemService<T, N>>
    extends Bloc<ItemDetailEvent, ItemDetailState> {
  ItemDetailBloc({
    required this.itemId,
    required this.service,
    required this.managerBloc,
  }) : super(ItemLoading()) {
    on<LoadItem>(_mapLoadToState);
    on<ReloadItem>(_mapReloadToState);
    on<UpdateItem<T>>(_mapUpdateToState);

    managerSubscription =
        managerBloc.stream.listen(_mapDetailManagerStateToEvent);
  }

  final int itemId;
  final S service;
  final ItemDetailManagerBloc<T, N, S> managerBloc;
  late StreamSubscription<ItemDetailManagerState> managerSubscription;

  void _mapLoadToState(LoadItem event, Emitter<ItemDetailState> emit) async {
    emit(
      ItemLoading(),
    );

    await _mapAnyLoadToState(emit);
  }

  void _mapReloadToState(
    ReloadItem event,
    Emitter<ItemDetailState> emit,
  ) async {
    await _mapAnyLoadToState(emit);
  }

  Future<void> _mapAnyLoadToState(Emitter<ItemDetailState> emit) async {
    try {
      final T item = await get();
      emit(
        ItemLoaded<T>(item),
      );
    } catch (e) {
      emit(
        ItemNotLoaded(e.toString()),
      );
    }
  }

  void _mapUpdateToState(UpdateItem<T> event, Emitter<ItemDetailState> emit) {
    emit(
      ItemLoaded<T>(event.item),
    );
  }

  void _mapDetailManagerStateToEvent(ItemDetailManagerState managerState) {
    if (managerState is ItemFieldUpdated<T>) {
      _mapFieldUpdatedToEvent(managerState);
    } else if (managerState is ItemImageUpdated<T>) {
      _mapImageUpdatedToEvent(managerState);
    }
  }

  void _mapFieldUpdatedToEvent(ItemFieldUpdated<T> event) {
    add(UpdateItem<T>(event.item));
  }

  void _mapImageUpdatedToEvent(ItemImageUpdated<T> event) {
    add(UpdateItem<T>(event.item));
  }

  @override
  Future<void> close() {
    managerSubscription.cancel();
    return super.close();
  }

  @mustCallSuper
  @protected
  Future<T> get() {
    return service.get(itemId);
  }
}
