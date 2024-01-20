import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode, PrimaryModel;

import 'package:logic/bloc/bloc_utils.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';

abstract class ItemRelationBloc<W extends PrimaryModel, N extends Object>
    extends Bloc<ItemRelationEvent, ItemRelationState> {
  ItemRelationBloc({
    required this.itemId,
    required this.managerBloc,
  }) : super(ItemRelationLoading()) {
    on<LoadItemRelation>(_mapLoadToState);
    on<ReloadItemRelation>(_mapReloadToState);
    on<UpdateItemRelation<W>>(_mapUpdateToState);

    _managerSubscription =
        managerBloc.stream.listen(_mapRelationManagerStateToEvent);
  }

  final String itemId;
  final ItemRelationManagerBloc<W, N> managerBloc;

  late final StreamSubscription<ItemRelationManagerState> _managerSubscription;

  void _mapLoadToState(
    LoadItemRelation event,
    Emitter<ItemRelationState> emit,
  ) async {
    emit(
      ItemRelationLoading(),
    );

    await _mapAnyLoadToState(emit);
  }

  void _mapReloadToState(
    ReloadItemRelation event,
    Emitter<ItemRelationState> emit,
  ) async {
    if (state is! ItemRelationLoading) {
      await _mapAnyLoadToState(emit);
    }
  }

  Future<void> _mapAnyLoadToState(Emitter<ItemRelationState> emit) async {
    try {
      final List<W> items = await getRelationItems();
      emit(
        ItemRelationLoaded<W>(items),
      );
    } catch (e) {
      _handleError(e, emit);
    }
  }

  void _handleError(Object e, Emitter<ItemRelationState> emit) {
    BlocUtils.handleErrorWithManager(
      e,
      emit,
      managerBloc,
      () => ItemRelationError(),
      (ErrorCode error, String errorDescription) =>
          WarnItemRelationNotLoaded(error, errorDescription),
    );
  }

  void _mapUpdateToState(
    UpdateItemRelation<W> event,
    Emitter<ItemRelationState> emit,
  ) {
    emit(
      ItemRelationLoaded<W>(event.otherItems),
    );
  }

  void _mapRelationManagerStateToEvent(ItemRelationManagerState managerState) {
    if (managerState is ItemRelationAdded) {
      _mapAddedToEvent(managerState);
    } else if (managerState is ItemRelationDeleted) {
      _mapDeletedToEvent(managerState);
    }
  }

  void _mapAddedToEvent(ItemRelationAdded managerState) {
    add(ReloadItemRelation());
  }

  void _mapDeletedToEvent(ItemRelationDeleted managerState) {
    add(ReloadItemRelation());
  }

  @override
  Future<void> close() {
    _managerSubscription.cancel();
    return super.close();
  }

  @protected
  Future<List<W>> getRelationItems();
}
