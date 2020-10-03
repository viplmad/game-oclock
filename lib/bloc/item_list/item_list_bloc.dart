import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/model.dart';

import 'item_list.dart';


abstract class ItemListBloc<T extends CollectionItem> extends Bloc<ItemListEvent, ItemListState> {

  ItemListBloc({@required this.collectionRepository});

  final ICollectionRepository collectionRepository;

  @override
  ItemListState get initialState => ItemListLoading();

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItemList) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemList<T>) {

      yield* _mapUpdateListToState(event);

    } else if(event is AddItem) {

      yield* _mapAddItemToState(event);

    } else if(event is DeleteItem<T>) {

      yield* _mapDeleteItemToState(event);

    } else if(event is UpdateView) {

      yield* _mapUpdateViewToState(event);

    } else if(event is UpdateSortOrder) {

      yield* _mapUpdateSortOrderToState(event);

    } else if(event is UpdateStyle) {

      yield* _mapUpdateStyleToState(event);

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

  Stream<ItemListState> _mapUpdateListToState(UpdateItemList<T> event) async* {

    yield ItemListLoaded<T>(
      event.items,
      event.viewIndex,
      event.style,
    );

  }

  Stream<ItemListState> _mapAddItemToState(AddItem event) async* {

    try {

      final T item = await createFuture(event);

      final UpdateItemList<T> updateEvent = _getUpdateAddList(item);

      yield ItemAdded<T>(
        item,
      );

      add(updateEvent);

    } catch (e) {

      yield ItemNotAdded(e.toString());

    }

  }

  Stream<ItemListState> _mapDeleteItemToState(DeleteItem<T> event) async* {

    try{

      await deleteFuture(event);

      final UpdateItemList<T> updateEvent = _getUpdateDeleteList(event.item);

      yield ItemDeleted<T>(
        event.item,
      );

      add(updateEvent);

    } catch (e) {

      yield ItemNotDeleted(e.toString());

    }

  }

  Stream<ItemListState> _mapUpdateViewToState(UpdateView event) async* {

    yield ItemListLoading();

    try {

      final List<T> items = await getReadViewStream(event).first;
      yield ItemListLoaded<T>(
        items,
        event.viewIndex,
      );

    } catch(e) {

      yield ItemListNotLoaded(e.toString());

    }

  }

  Stream<ItemListState> _mapUpdateSortOrderToState(UpdateSortOrder event) async* {

    if(state is ItemListLoaded<T>) {
      final List<T> reversedItems = (state as ItemListLoaded<T>).items.reversed.toList();

      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      yield ItemListLoaded<T>(reversedItems, viewIndex, style);
    }

  }

  Stream<ItemListState> _mapUpdateStyleToState(UpdateStyle event) async* {

    if(state is ItemListLoaded<T>) {
      final rotatingIndex = ((state as ItemListLoaded<T>).style.index + 1) % ListStyle.values.length;
      final ListStyle updatedStyle = ListStyle.values.elementAt(rotatingIndex);

      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;

      yield ItemListLoaded<T>(items, viewIndex, updatedStyle);
    }

  }

  UpdateItemList<T> _getUpdateAddList(T addedItem) {

    List<T> items = List<T>();
    int viewIndex;
    ListStyle style;
    if(state is ItemListLoaded<T>) {
      items = (state as ItemListLoaded<T>).items;
      viewIndex = (state as ItemListLoaded<T>).viewIndex;
      style = (state as ItemListLoaded<T>).style;
    }

    final List<T> updatedItems = List.from(items)..add(addedItem);

    return UpdateItemList<T>(updatedItems, viewIndex, style);

  }

  UpdateItemList<T> _getUpdateDeleteList(T deletedItem) {

    List<T> items = List<T>();
    int viewIndex;
    ListStyle style;
    if(state is ItemListLoaded<T>) {
      items = (state as ItemListLoaded<T>).items;
      viewIndex = (state as ItemListLoaded<T>).viewIndex;
      style = (state as ItemListLoaded<T>).style;
    }

    final List<T> updatedItems = items
        .where((T item) => item.ID != deletedItem.ID)
        .toList();

    return UpdateItemList<T>(updatedItems, viewIndex, style);

  }

  @override
  Future<void> close() {

    return super.close();

  }

  external Stream<List<T>> getReadAllStream();
  external Future<T> createFuture(AddItem event);
  external Future<dynamic> deleteFuture(DeleteItem<T> event);
  external Stream<List<T>> getReadViewStream(UpdateView event);

}