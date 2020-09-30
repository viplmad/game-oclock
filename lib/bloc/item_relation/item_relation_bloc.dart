import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


abstract class ItemRelationBloc<T extends CollectionItem, W extends CollectionItem> extends Bloc<ItemRelationEvent, ItemRelationState> {

  ItemRelationBloc({@required this.itemID, @required this.itemBloc});

  final int itemID;
  final ItemBloc<T> itemBloc;
  ICollectionRepository get collectionRepository => itemBloc.collectionRepository;

  @override
  ItemRelationState get initialState => ItemRelationLoading();

  @override
  Stream<ItemRelationState> mapEventToState(ItemRelationEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItemRelation) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemRelation<W>) {

      yield* _mapUpdateRelationToState(event);

    } else if(event is AddItemRelation<T, W>) {

      yield* _mapAddRelationToState(event);

    } else if(event is DeleteItemRelation<T, W>) {

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

  Stream<ItemRelationState> _mapAddRelationToState(AddItemRelation<T, W> event) async* {

    try{

      await addRelationFuture(event);

      List<W> items = List<W>();
      if(state is ItemRelationLoaded<W>) {
        items = (state as ItemRelationLoaded<W>).otherItems;
      }

      yield ItemRelationAdded<W>(
        event.otherItem,
      );

      final List<W> updatedItems = List.from(items)..add(event.otherItem);

      add(UpdateItemRelation<W>(updatedItems));

    } catch(e) {

      yield ItemRelationNotAdded(e);

    }

  }

  Stream<ItemRelationState> _mapDeleteRelationToState(DeleteItemRelation<T, W> event) async* {

    try{

      await deleteRelationFuture(event);

      List<W> items = List<W>();
      if(state is ItemRelationLoaded<W>) {
        items = (state as ItemRelationLoaded<W>).otherItems;
      }

      yield ItemRelationDeleted<W>(
        event.otherItem,
      );

      final List<W> updatedItems = items
          .where((W item) => item.ID != event.otherItem.ID)
          .toList();

      add(UpdateItemRelation<W>(updatedItems));

    } catch(e) {

      yield ItemRelationNotDeleted(e);

    }

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
  Future<dynamic> addRelationFuture(AddItemRelation<T, W> event) {

    return Future.error("Relation does not exist");

  }
  @mustCallSuper
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<T, W> event) {

    return Future.error("Relation does not exist");

  }

}