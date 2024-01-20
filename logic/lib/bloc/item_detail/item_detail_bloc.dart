import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode, PrimaryModel;

import 'package:logic/service/service.dart' show ItemService;
import 'package:logic/bloc/bloc_utils.dart';

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

    _managerSubscription =
        managerBloc.stream.listen(_mapDetailManagerStateToEvent);
  }

  final String itemId;
  final S service;
  final ItemDetailManagerBloc<T, N, S> managerBloc;

  late final StreamSubscription<ItemDetailManagerState> _managerSubscription;

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
    if (state is ItemLoaded<T>) {
      final T previousItem = (state as ItemLoaded<T>).item;

      try {
        T item = await _get();

        if (event.forceAdditionalFields) {
          item = await getAdditionalFields(item);
        } else {
          item = addAdditionalFields(item, previousItem);
        }

        emit(
          ItemLoaded<T>(item),
        );
      } catch (e) {
        _handleError(e, emit);
      }
    } else if (state is! ItemLoading) {
      await _mapAnyLoadToState(emit);
    }
  }

  Future<void> _mapAnyLoadToState(Emitter<ItemDetailState> emit) async {
    try {
      T item = await _get();
      item = await getAdditionalFields(item);

      emit(
        ItemLoaded<T>(item),
      );
    } catch (e) {
      _handleError(e, emit);
    }
  }

  void _handleError(Object e, Emitter<ItemDetailState> emit) {
    BlocUtils.handleErrorWithManager(
      e,
      emit,
      managerBloc,
      () => ItemDetailError(),
      (ErrorCode error, String errorDescription) =>
          WarnItemDetailNotLoaded(error, errorDescription),
    );
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
    _managerSubscription.cancel();
    return super.close();
  }

  Future<T> _get() {
    return service.get(itemId);
  }

  @protected
  Future<T> getAdditionalFields(T item) async {
    return item;
  }

  @protected
  T addAdditionalFields(T item, T previousItem) {
    return item;
  }
}
