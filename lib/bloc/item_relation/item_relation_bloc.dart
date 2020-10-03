import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_relation.dart';


abstract class ItemRelationBloc<T extends CollectionItem, W extends CollectionItem> extends Bloc<ItemRelationEvent, ItemRelationState> {

  ItemRelationBloc({@required this.itemID, @required this.collectionRepository});

  final int itemID;
  final ICollectionRepository collectionRepository;

  @override
  ItemRelationState get initialState => ItemRelationLoading();

  @override
  Stream<ItemRelationState> mapEventToState(ItemRelationEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItemRelation) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemRelation<W>) {

      yield* _mapUpdateRelationToState(event);

    } else if(event is AddItemRelation<W>) {

      yield* _mapAddRelationToState(event);

    } else if(event is DeleteItemRelation<W>) {

      yield* _mapDeleteRelationToState(event);

    }

  }

  Stream<ItemRelationState> _checkConnection() async* {

    if(collectionRepository.isClosed()) {
      yield ItemRelationNotLoaded("Connection lost. Trying to reconnect");

      try {

        collectionRepository.reconnect();
        await collectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<ItemRelationState> _mapLoadToState() async* {

    yield ItemRelationLoading();

    try {

      final List<W> items = await getRelationStream().first;
      yield ItemRelationLoaded<W>(items);

    } catch (e) {

      yield ItemRelationNotLoaded(e.toString());

    }

  }

  Stream<ItemRelationState> _mapUpdateRelationToState(UpdateItemRelation<W> event) async* {

    yield ItemRelationLoaded<W>(
      event.otherItems,
    );

  }

  Stream<ItemRelationState> _mapAddRelationToState(AddItemRelation<W> event) async* {

    try{

      await addRelationFuture(event);

      final UpdateItemRelation<W> updateEvent = _getUpdateAddList(event.otherItem);

      yield ItemRelationAdded<W>(
        event.otherItem,
      );

      add(updateEvent);

    } catch(e) {

      yield ItemRelationNotAdded(e);

    }

  }

  Stream<ItemRelationState> _mapDeleteRelationToState(DeleteItemRelation<W> event) async* {

    try{

      await deleteRelationFuture(event);

      final UpdateItemRelation<W> updateEvent = _getUpdateDeleteList(event.otherItem);

      yield ItemRelationDeleted<W>(
        event.otherItem,
      );

      add(updateEvent);

    } catch(e) {

      yield ItemRelationNotDeleted(e);

    }

  }

  UpdateItemRelation<W> _getUpdateAddList(W addedItem) {

    List<W> items = List<W>();
    if(state is ItemRelationLoaded<W>) {
      items = (state as ItemRelationLoaded<W>).otherItems;
    }

    final List<W> updatedItems = List.from(items)..add(addedItem);

    return UpdateItemRelation(updatedItems);

  }

  UpdateItemRelation<W> _getUpdateDeleteList(W deletedItem) {

    List<W> items = List<W>();
    if(state is ItemRelationLoaded<W>) {
      items = (state as ItemRelationLoaded<W>).otherItems;
    }

    final List<W> updatedItems = items
        .where((W item) => item.ID != deletedItem.ID)
        .toList();

    return UpdateItemRelation(updatedItems);

  }

  @override
  Future<void> close() {

    return super.close();

  }

  @mustCallSuper
  Stream<List<W>> getRelationStream() {

    return Stream.error("Relation does not exist");

  }
  @mustCallSuper
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    return Future.error("Relation does not exist");

  }
  @mustCallSuper
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    return Future.error("Relation does not exist");

  }

}