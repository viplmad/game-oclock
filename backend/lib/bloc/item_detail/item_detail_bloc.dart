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
    await _mapAnyLoadToState(emit, event.forceAdditionalFields);
  }

  Future<void> _mapAnyLoadToState(
    Emitter<ItemDetailState> emit, [
    bool forceAdditionalFields = true,
  ]) async {
    try {
      T item = await _get();
      if (forceAdditionalFields) {
        item = await getAdditionalFields(item);
      } else {
        if (state is ItemLoaded<T>) {
          final T previousItem = (state as ItemLoaded<T>).item;
          item = addAdditionalFields(item, previousItem);
        }
      }
      emit(
        ItemLoaded<T>(item),
      );
    } catch (e) {
      managerBloc.add(WarnItemDetailNotLoaded(e.toString()));
      emit(
        ItemDetailError(),
      );
    }
  }

  void _mapDetailManagerStateToEvent(ItemDetailManagerState managerState) {
    if (managerState is ItemFieldUpdated) {
      _mapFieldUpdatedToEvent(managerState);
    } else if (managerState is ItemImageUpdated) {
      _mapImageUpdatedToEvent(managerState);
    }
  }

  void _mapFieldUpdatedToEvent(ItemFieldUpdated event) {
    add(const ReloadItem());
  }

  void _mapImageUpdatedToEvent(ItemImageUpdated event) {
    add(const ReloadItem());
  }

  @override
  Future<void> close() {
    managerSubscription.cancel();
    return super.close();
  }

  Future<T> _get() {
    return service.get(itemId);
  }

  @protected
  Future<T> getAdditionalFields(T item) async => item;
  @protected
  T addAdditionalFields(T item, T previousItem) => item;
}
