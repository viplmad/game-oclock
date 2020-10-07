import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


abstract class ItemListBloc<T extends CollectionItem> extends Bloc<ItemListEvent, ItemListState> {

  ItemListBloc({@required this.iCollectionRepository, @required this.managerBloc}) : super(ItemListLoading()) {

    managerSubscription = managerBloc.listen(mapListManagerStateToEvent);

  }

  final ICollectionRepository iCollectionRepository;
  final ItemListManagerBloc<T> managerBloc;
  StreamSubscription<ItemListManagerState> managerSubscription;

  @override
  Stream<ItemListState> mapEventToState(ItemListEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItemList) {

      yield* _mapLoadToState();

    } else if(event is UpdateItemList<T>) {

      yield* _mapUpdateListToState(event);

    } else if(event is UpdateListItem<T>) {

      yield* _mapUpdateItemToState(event);

    } else if(event is UpdateView) {

      yield* _mapUpdateViewToState(event);

    } else if(event is UpdateSortOrder) {

      yield* _mapUpdateSortOrderToState(event);

    } else if(event is UpdateStyle) {

      yield* _mapUpdateStyleToState(event);

    }

  }

  Stream<ItemListState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {
      yield ItemListNotLoaded("Connection lost. Trying to reconnect");

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

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

  Stream<ItemListState> _mapUpdateItemToState(UpdateListItem<T> event) async* {

    if(state is ItemListLoaded<T>) {
      List<T> items = (state as ItemListLoaded<T>).items;

      final int listItemIndex = items.indexWhere((T item) => item.ID == event.item.ID);
      final T listItem = items.elementAt(listItemIndex);

      if(listItem != event.item) {
        items[listItemIndex] = event.item;

        final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
        final ListStyle style = (state as ItemListLoaded<T>).style;

        yield ItemListLoaded<T>(
          items,
          viewIndex,
          style,
        );
      }

    }

  }

  Stream<ItemListState> _mapUpdateViewToState(UpdateView event) async* {

    ListStyle style;
    if(state is ItemListLoaded<T>) {
       style = (state as ItemListLoaded<T>).style;
    }

    yield ItemListLoading();

    try {

      final List<T> items = await getReadViewStream(event).first;
      yield ItemListLoaded<T>(
        items,
        event.viewIndex,
        style,
      );

    } catch(e) {

      yield ItemListNotLoaded(e.toString());

    }

  }

  Stream<ItemListState> _mapUpdateSortOrderToState(UpdateSortOrder event) async* {

    if(state is ItemListLoaded<T>) {
      final List<T> reversedItems = (state as ItemListLoaded<T>).items.reversed.toList(growable: false);

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

  void mapListManagerStateToEvent(ItemListManagerState managerState) {

    if(managerState is ItemAdded<T>) {

      _mapAddedToEvent(managerState);

    } else if(managerState is ItemDeleted<T>) {

      _mapDeletedToEvent(managerState);

    }

  }

  void _mapAddedToEvent(ItemAdded<T> managerState) {

    if(state is ItemListLoaded<T>) {
      List<T> items = (state as ItemListLoaded<T>).items;
      int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      ListStyle style = (state as ItemListLoaded<T>).style;

      final List<T> updatedItems = List.from(items)..add(managerState.item);

      add(
        UpdateItemList<T>(
          updatedItems,
          viewIndex,
          style,
        ),
      );
    }

  }

  void _mapDeletedToEvent(ItemDeleted<T> managerState) {

    if(state is ItemListLoaded<T>) {
      List<T> items = (state as ItemListLoaded<T>).items;
      int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      ListStyle style = (state as ItemListLoaded<T>).style;

      final List<T> updatedItems = items
          .where((T item) => item.ID != managerState.item.ID)
          .toList(growable: false);

      add(
        UpdateItemList<T>(
          updatedItems,
          viewIndex,
          style,
        ),
      );
    }

  }

  @override
  Future<void> close() {

    managerSubscription?.cancel();
    return super.close();

  }

  external Stream<List<T>> getReadAllStream();
  external Stream<List<T>> getReadViewStream(UpdateView event);

}