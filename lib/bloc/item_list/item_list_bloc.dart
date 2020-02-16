import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


abstract class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {

  ItemListBloc({@required this.itemBloc}) {

    itemSubscription = itemBloc.listen( mapItemStateToEvent );

  }

  final ItemBloc itemBloc;
  StreamSubscription<ItemState> itemSubscription;
  ICollectionRepository get collectionRepository => itemBloc.collectionRepository;

  @override
  ItemListState get initialState => ItemListLoading();

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {

    if(event is LoadItemList) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemList) {

      yield* _mapListUpdateToState(event);

    } else if(event is UpdateView) {

      yield* _mapUpdateViewToState(event);

    } else if(event is UpdateSortOrder) {

      yield* _mapUpdateSortOrderToState(event);

    }

  }

  Stream<ItemListState> _mapLoadToState() async* {

    yield ItemListLoading();

    try {

      final List<CollectionItem> items = await getReadAllStream().first;
      yield ItemListLoaded(items, "Main");

    } catch (e) {

      yield ItemListNotLoaded(e.toString());

    }

  }

  Stream<ItemListState> _mapListUpdateToState(UpdateItemList event) async* {

    if(state is ItemListLoaded) {
      final String activeView = (state as ItemListLoaded).view;
      yield ItemListLoaded(event.items, activeView);
    }

  }

  Stream<ItemListState> _mapUpdateViewToState(UpdateView event) async* {

    try {

      final List<CollectionItem> items = await getReadViewStream(event).first;
      yield ItemListLoaded(items, event.view);

    } catch(e) {

      yield ItemListNotLoaded(e.toString());

    }

  }

  Stream<ItemListState> _mapUpdateSortOrderToState(UpdateSortOrder event) async* {

    if(state is ItemListLoaded) {
      final List<CollectionItem> reversedItems = (state as ItemListLoaded).items.reversed.toList();
      final String activeView = (state as ItemListLoaded).view;
      yield ItemListLoaded(reversedItems, activeView);
    }

  }

  void mapItemStateToEvent(ItemState itemState) {

    if(itemState is ItemAdded) {

      _mapAddedToEvent(itemState);

    } else if(itemState is ItemDeleted) {

      _mapDeletedToEvent(itemState);

    } else if(itemState is ItemFieldUpdated) {

      _mapUpdatedFieldToEvent(itemState);

    }

  }

  void _mapAddedToEvent(ItemAdded itemState) {

    if(state is ItemListLoaded) {
      final itemAdded = itemState.item;
      final List<CollectionItem> updatedItems = List.from(
          (state as ItemListLoaded).items)..add(itemAdded);

      add(UpdateItemList(updatedItems));
    }

  }

  void _mapDeletedToEvent(ItemDeleted itemState) {

    if(state is ItemListLoaded) {
      final itemDeleted = itemState.item;
      final List<CollectionItem> updatedItems = (state as ItemListLoaded)
          .items
          .where((CollectionItem item) => item.ID != itemDeleted.ID)
          .toList();

      add(UpdateItemList(updatedItems));
    }

  }

  void _mapUpdatedFieldToEvent(ItemFieldUpdated itemState) {

    if(state is ItemListLoaded) {
      final itemUpdated = itemState.item;
      final List<CollectionItem> updatedItems = (state as ItemListLoaded)
          .items
          .map((CollectionItem item) {
            if(item.ID == itemUpdated.ID) {
              return itemUpdated;
            }

            return item;
          }).toList();

      add(UpdateItemList(updatedItems));
    }

  }

  @override
  Future<void> close() {

    itemSubscription?.cancel();
    return super.close();

  }

  external Stream<List<CollectionItem>> getReadAllStream();
  external Stream<List<CollectionItem>> getReadViewStream(UpdateView event);

}