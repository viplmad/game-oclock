import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


abstract class ItemListBloc<T extends CollectionItem> extends Bloc<ItemListEvent, ItemListState> {

  ItemListBloc({@required this.itemBloc}) {

    itemSubscription = itemBloc.listen( mapItemStateToEvent );

  }

  final ItemBloc<T> itemBloc;
  StreamSubscription<ItemState> itemSubscription;
  ICollectionRepository get collectionRepository => itemBloc.collectionRepository;

  @override
  ItemListState get initialState => ItemListLoading();

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItemList) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemList<T>) {

      yield* _mapListUpdateListToState(event);

    } else if(event is UpdateView) {

      yield* _mapUpdateViewToState(event);

    } else if(event is UpdateSortOrder) {

      yield* _mapUpdateSortOrderToState(event);

    } else if(event is UpdateIsGrid) {

      yield* _mapUpdateIsGridToState(event);

    }

  }

  Stream<ItemListState> _checkConnection() async* {

    if(collectionRepository.isClosed()) {
      yield ItemListNotLoaded("Connection lost. Trying to reconnect");

      try {

        collectionRepository.reconnect();
        await collectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<ItemListState> _mapLoadToState() async* {

    yield ItemListLoading();

    try {

      final List<T> items = await getReadAllStream().first;
      yield ItemListLoaded<T>(items);

    } catch (e) {

      yield ItemListNotLoaded(e.toString());

    }

  }

  Stream<ItemListState> _mapListUpdateListToState(UpdateItemList<T> event) async* {

    if(state is ItemListLoaded<T>) {
      final String activeView = (state as ItemListLoaded<T>).view;
      final bool isGrid = (state as ItemListLoaded<T>).isGrid;
      yield ItemListLoaded<T>(event.items, activeView, isGrid);
    }

  }

  Stream<ItemListState> _mapUpdateViewToState(UpdateView event) async* {

    yield ItemListLoading();

    try {

      final List<T> items = await getReadViewStream(event).first;
      yield ItemListLoaded<T>(items, event.view);

    } catch(e) {

      yield ItemListNotLoaded(e.toString());

    }

  }

  Stream<ItemListState> _mapUpdateSortOrderToState(UpdateSortOrder event) async* {

    if(state is ItemListLoaded<T>) {
      final List<T> reversedItems = (state as ItemListLoaded<T>).items.reversed.toList();

      final String activeView = (state as ItemListLoaded<T>).view;
      final bool isGrid = (state as ItemListLoaded<T>).isGrid;

      yield ItemListLoaded<T>(reversedItems, activeView, isGrid);
    }

  }

  Stream<ItemListState> _mapUpdateIsGridToState(UpdateIsGrid event) async* {

    if(state is ItemListLoaded<T>) {
      final bool isGrid = !((state as ItemListLoaded<T>).isGrid);

      final List<T> items = (state as ItemListLoaded<T>).items;
      final String activeView = (state as ItemListLoaded<T>).view;

      yield ItemListLoaded<T>(items, activeView, isGrid);
    }

  }

  void mapItemStateToEvent(ItemState itemState) {

    if(itemState is ItemAdded<T>) {

      _mapAddedToEvent(itemState);

    } else if(itemState is ItemDeleted<T>) {

      _mapDeletedToEvent(itemState);

    } else if(itemState is ItemFieldUpdated<T>) {

      _mapUpdatedFieldToEvent(itemState);

    }

  }

  void _mapAddedToEvent(ItemAdded<T> itemState) {

    if(state is ItemListLoaded<T>) {
      final itemAdded = itemState.item;
      final List<T> updatedItems = List.from(
          (state as ItemListLoaded<T>).items)..add(itemAdded);

      add(UpdateItemList<T>(updatedItems));
    }

  }

  void _mapDeletedToEvent(ItemDeleted<T> itemState) {

    if(state is ItemListLoaded<T>) {
      final itemDeleted = itemState.item;
      final List<T> updatedItems = (state as ItemListLoaded<T>)
          .items
          .where((T item) => item.ID != itemDeleted.ID)
          .toList();

      add(UpdateItemList<T>(updatedItems));
    }

  }

  void _mapUpdatedFieldToEvent(ItemFieldUpdated<T> itemState) {

    if(state is ItemListLoaded<T>) {
      final itemUpdated = itemState.item;
      final List<T> updatedItems = (state as ItemListLoaded<T>)
          .items
          .map((T item) {
            if(item.ID == itemUpdated.ID) {
              return itemUpdated;
            }

            return item;
          }).toList();

      add(UpdateItemList<T>(updatedItems));
    }

  }

  @override
  Future<void> close() {

    itemSubscription?.cancel();
    return super.close();

  }

  external Stream<List<T>> getReadAllStream();
  external Stream<List<T>> getReadViewStream(UpdateView event);

}