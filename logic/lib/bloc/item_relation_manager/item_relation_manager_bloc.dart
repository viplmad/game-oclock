import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart' show PrimaryModel;

import 'item_relation_manager.dart';

abstract class ItemRelationManagerBloc<W extends PrimaryModel, N extends Object>
    extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState> {
  ItemRelationManagerBloc({
    required this.itemId,
  }) : super(ItemRelationManagerInitialised()) {
    on<AddItemRelation<N>>(_mapAddRelationToState);
    on<DeleteItemRelation<W>>(_mapDeleteRelationToState);
    on<WarnItemRelationNotLoaded>(_mapWarnNotLoadedToState);
  }

  final String itemId;

  void _mapAddRelationToState(
    AddItemRelation<N> event,
    Emitter<ItemRelationManagerState> emit,
  ) async {
    try {
      await addRelation(event);
      emit(
        ItemRelationAdded(),
      );
    } catch (e) {
      emit(
        ItemRelationNotAdded(e.toString()),
      );
    }

    emit(
      ItemRelationManagerInitialised(),
    );
  }

  void _mapDeleteRelationToState(
    DeleteItemRelation<W> event,
    Emitter<ItemRelationManagerState> emit,
  ) async {
    try {
      await deleteRelation(event);
      emit(
        ItemRelationDeleted(),
      );
    } catch (e) {
      emit(
        ItemRelationNotDeleted(e.toString()),
      );
    }

    emit(
      ItemRelationManagerInitialised(),
    );
  }

  void _mapWarnNotLoadedToState(
    WarnItemRelationNotLoaded event,
    Emitter<ItemRelationManagerState> emit,
  ) {
    emit(ItemRelationNotLoaded(event.error));
  }

  @protected
  Future<void> addRelation(AddItemRelation<N> event);
  @protected
  Future<void> deleteRelation(DeleteItemRelation<W> event);
}
