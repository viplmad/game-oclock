import 'dart:async';

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
      if (!event.silent) {
        emit(
          ItemLoading(),
        );
      }

      await _mapAnyLoadToState(emit);
    } else if (state is! ItemLoading) {
      await _mapAnyLoadToState(emit);
    }
  }

  Future<void> _mapAnyLoadToState(Emitter<ItemDetailState> emit) async {
    try {
      final T item = await _get();
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
    add(const ReloadItem(silent: true));
  }

  void _mapImageUpdatedToEvent(ItemImageUpdated event) {
    add(const ReloadItem(silent: true));
  }

  @override
  Future<void> close() {
    _managerSubscription.cancel();
    return super.close();
  }

  Future<T> _get() {
    return service.get(itemId);
  }
}
