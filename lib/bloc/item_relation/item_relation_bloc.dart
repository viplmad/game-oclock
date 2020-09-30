import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


abstract class ItemRelationBloc<T extends CollectionItem, W extends CollectionItem> extends Bloc<ItemRelationEvent, ItemRelationState> {

  ItemRelationBloc({@required this.itemID, @required this.itemBloc}) {

    itemSubscription = itemBloc.listen( mapItemStateToEvent );

  }

  final int itemID;
  final ItemBloc<T> itemBloc;
  StreamSubscription<ItemState> itemSubscription;
  ICollectionRepository get collectionRepository => itemBloc.collectionRepository;

  @override
  ItemRelationState get initialState => ItemRelationLoading();

  @override
  Stream<ItemRelationState> mapEventToState(ItemRelationEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItemRelation) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemRelation<W>) {

      yield* _mapUpdateToState(event);

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

  Stream<ItemRelationState> _mapUpdateToState(UpdateItemRelation<W> event) async* {

    yield ItemRelationLoaded<W>(event.otherItems);

  }

  void mapItemStateToEvent(ItemState itemState) {

    if(itemState is ItemRelationAdded<W>) {

      _mapRelationAddedToEvent(itemState);

    } else if(itemState is ItemRelationDeleted<W>) {

      _mapRelationDeletedToEvent(itemState);

    }

  }

  void _mapRelationAddedToEvent(ItemRelationAdded<W> itemState) {

    if(state is ItemRelationLoaded<W>) {
      final W relationItemAdded = itemState.otherItem;
      final List<W> updatedItems = List.from(
          (state as ItemRelationLoaded<W>).otherItems)..add(relationItemAdded);

      add(UpdateItemRelation<W>(updatedItems));
    }

  }

  void _mapRelationDeletedToEvent(ItemRelationDeleted<W> itemState) {

    if(state is ItemRelationLoaded<W>) {
      final W itemDeleted = itemState.otherItem;
      final List<W> updatedItems = (state as ItemRelationLoaded<W>)
          .otherItems
          .where((W item) => item.ID != itemDeleted.ID)
          .toList();

      add(UpdateItemRelation<W>(updatedItems));
    }

  }

  @override
  Future<void> close() {

    itemSubscription?.cancel();
    return super.close();

  }

  @mustCallSuper
  Stream<List<W>> getRelationStream() {

    return Stream.error("Relation does not exist");

  }

}