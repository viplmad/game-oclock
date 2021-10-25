import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'item_relation_manager.dart';


abstract class ItemRelationManagerBloc<T extends Item, ID extends Object, W extends Item> extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState> {
  ItemRelationManagerBloc({
    required this.id,
    required this.collectionRepository,
  }) : super(ItemRelationManagerInitialised()) {

    on<AddItemRelation<W>>(_mapAddRelationToState);
    on<DeleteItemRelation<W>>(_mapDeleteRelationToState);

  }

  final ID id;
  final GameCollectionRepository collectionRepository;

  void _checkConnection(Emitter<ItemRelationManagerState> emit) async {

    if(collectionRepository.isClosed()) {

      try {

        collectionRepository.reconnect();
        await collectionRepository.open();

      } catch (e) {

        emit(
          ItemRelationNotAdded(e.toString()),
        );

      }
    }

  }

  void _mapAddRelationToState(AddItemRelation<W> event, Emitter<ItemRelationManagerState> emit) async {

    _checkConnection(emit);

    try{

      await addRelationFuture(event);
      emit(
        ItemRelationAdded<W>(event.otherItem),
      );

    } catch(e) {

      emit(
        ItemRelationNotAdded(e.toString()),
      );

    }

    emit(
      ItemRelationManagerInitialised(),
    );

  }

  void _mapDeleteRelationToState(DeleteItemRelation<W> event, Emitter<ItemRelationManagerState> emit) async {

    _checkConnection(emit);

    try{

      await deleteRelationFuture(event);
      emit(
        ItemRelationDeleted<W>(event.otherItem),
      );

    } catch(e) {

      emit(
        ItemRelationNotDeleted(e.toString()),
      );

    }

    emit(
      ItemRelationManagerInitialised(),
    );

  }

  @mustCallSuper
  @protected
  Future<Object?> addRelationFuture(AddItemRelation<W> event) {

    return Future<Object?>.error('Relation does not exist');

  }

  @mustCallSuper
  @protected
  Future<Object?> deleteRelationFuture(DeleteItemRelation<W> event) {

    return Future<Object?>.error('Relation does not exist');

  }
}