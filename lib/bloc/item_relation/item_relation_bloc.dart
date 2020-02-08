import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';

abstract class ItemRelationBloc extends Bloc<ItemRelationEvent, ItemRelationState> {

  ItemRelationBloc({@required this.itemID, @required this.relationField, @required this.itemBloc}) {

    itemSubscription = itemBloc.listen( mapItemStateToEvent );

  }

  final int itemID;
  final String relationField;
  final ItemBloc itemBloc;
  StreamSubscription<ItemState> itemSubscription;
  ICollectionRepository get collectionRepository => itemBloc.collectionRepository;

  @override
  ItemRelationState get initialState => ItemRelationLoading();

  @override
  Stream<ItemRelationState> mapEventToState(ItemRelationEvent event) async* {

    if(event is LoadItemRelation) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemRelation) {

    }

  }

  Stream<ItemRelationState> _mapLoadToState() async* {

    yield ItemRelationLoading();

    try {

      final List<CollectionItem> items = await getRelationStream().first;
      yield ItemRelationLoaded(items);

    } catch (e) {

      yield ItemRelationNotLoaded(e.toString());

    }

  }

  Stream<ItemRelationState> _mapListUpdateToState(UpdateItemRelation event) async* {

    yield ItemRelationLoaded(event.items);

  }

  void mapItemStateToEvent(ItemState itemState) {

    if(state is ItemRelationAdded) {

      _mapRelationAddedToEvent(itemState);

    } else if(state is ItemRelationDeleted) {

      _mapRelationDeletedToEvent(itemState);

    }

  }

  void _mapRelationAddedToEvent(ItemRelationAdded itemState) {

    if(state is ItemRelationLoaded
        && relationField == itemState.field) {
      final relationItemAdded = itemState.item;
      final List<CollectionItem> updatedItems = List.from(
          (state as ItemRelationLoaded).items)..add(relationItemAdded);

      add(UpdateItemRelation(updatedItems));
    }

  }

  void _mapRelationDeletedToEvent(ItemRelationDeleted itemState) {

    if(state is ItemRelationLoaded
        && relationField == itemState.field) {
      final itemDeleted = itemState.item;
      final List<CollectionItem> updatedItems = (state as ItemRelationLoaded)
          .items
          .where((CollectionItem item) => item.ID != itemDeleted.ID)
          .toList();

      add(UpdateItemRelation(updatedItems));
    }

  }

  @override
  Future<void> close() {

    itemSubscription?.cancel();
    return super.close();

  }

  external Stream<List<CollectionItem>> getRelationStream();

}