import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'item_relation_manager.dart';

abstract class ItemRelationManagerBloc<W extends PrimaryModel>
    extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState> {
  ItemRelationManagerBloc({
    required this.itemId,
  }) : super(ItemRelationManagerInitialised()) {
    on<AddItemRelation<W>>(_mapAddRelationToState);
    on<DeleteItemRelation<W>>(_mapDeleteRelationToState);
    on<WarneItemRelationNotLoaded>(_mapWarnNotLoadedToState);
  }

  final String itemId;

  void _mapAddRelationToState(
    AddItemRelation<W> event,
    Emitter<ItemRelationManagerState> emit,
  ) async {
    try {
      await addRelation(event);
      emit(
        ItemRelationAdded<W>(event.otherItem),
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
        ItemRelationDeleted<W>(event.otherItem),
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
    WarneItemRelationNotLoaded event,
    Emitter<ItemRelationManagerState> emit,
  ) {
    emit(ItemRelationNotLoaded(event.error));
  }

  @protected
  Future<void> addRelation(AddItemRelation<W> event);
  @protected
  Future<void> deleteRelation(DeleteItemRelation<W> event);
}
