import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';

abstract class ItemRelationBloc<W extends PrimaryModel>
    extends Bloc<ItemRelationEvent, ItemRelationState> {
  ItemRelationBloc({
    required this.itemId,
    required this.managerBloc,
  }) : super(ItemRelationLoading()) {
    on<LoadItemRelation>(_mapLoadToState);
    on<ReloadItemRelation>(_mapReloadToState);
    on<UpdateItemRelation<W>>(_mapUpdateToState);

    managerSubscription =
        managerBloc.stream.listen(mapRelationManagerStateToEvent);
  }

  final int itemId;
  final ItemRelationManagerBloc<W> managerBloc;
  late StreamSubscription<ItemRelationManagerState> managerSubscription;

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
    await _mapAnyLoadToState(emit);
  }

  Future<void> _mapAnyLoadToState(Emitter<ItemRelationState> emit) async {
    try {
      final List<W> items = await getRelationItems();
      emit(
        ItemRelationLoaded<W>(items),
      );
    } catch (e) {
      emit(
        ItemRelationNotLoaded(e.toString()),
      );
    }
  }

  void _mapUpdateToState(
    UpdateItemRelation<W> event,
    Emitter<ItemRelationState> emit,
  ) {
    emit(
      ItemRelationLoaded<W>(event.otherItems),
    );
  }

  void mapRelationManagerStateToEvent(ItemRelationManagerState managerState) {
    if (managerState is ItemRelationAdded<W>) {
      _mapAddedToEvent(managerState);
    } else if (managerState is ItemRelationDeleted<W>) {
      _mapDeletedToEvent(managerState);
    }
  }

  void _mapAddedToEvent(ItemRelationAdded<W> managerState) {
    if (state is ItemRelationLoaded<W>) {
      final List<W> items = (state as ItemRelationLoaded<W>).otherItems;

      final List<W> updatedItems = List<W>.from(items)
        ..add(managerState.otherItem);

      add(UpdateItemRelation<W>(updatedItems));
    }
  }

  void _mapDeletedToEvent(ItemRelationDeleted<W> managerState) {
    if (state is ItemRelationLoaded<W>) {
      final List<W> items = (state as ItemRelationLoaded<W>).otherItems;

      final List<W> updatedItems = items
          .where((W item) => item != managerState.otherItem)
          .toList(growable: false);

      add(UpdateItemRelation<W>(updatedItems));
    }
  }

  @override
  Future<void> close() {
    managerSubscription.cancel();
    return super.close();
  }

  @protected
  Future<List<W>> getRelationItems();
}
