import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';

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

    } else if(event is UpdateSort) {

      yield* _mapUpdateSortToState(event);

    } else if(event is UpdateSortOrder) {

      yield* _mapUpdateSortOrderToState(event);

    }

  }

  Stream<ItemListState> _mapLoadToState() async* {

    yield ItemListLoading();

    try {

      final List<CollectionItem> items = await getReadStream().first;
      yield ItemListLoaded(items);

    } catch (e) {

      yield ItemListNotLoaded(e.toString());

    }

  }

  Stream<ItemListState> _mapListUpdateToState(UpdateItemList event) async* {

    yield ItemListLoaded(event.items);

  }

  Stream<ItemListState> _mapUpdateSortToState(UpdateSort event) async* {

  }

  Stream<ItemListState> _mapUpdateSortOrderToState(UpdateSortOrder event) async* {

  }

  void mapItemStateToEvent(ItemState itemState) {

    if(state is ItemAdded) {

      _mapAddedToEvent(itemState);

    } else if(state is ItemDeleted) {

      _mapDeletedToEvent(itemState);

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

  @override
  Future<void> close() {

    itemSubscription?.cancel();
    return super.close();

  }

  external Stream<List<CollectionItem>> getReadStream();

}