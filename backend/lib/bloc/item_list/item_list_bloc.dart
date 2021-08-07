import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/model/list_style.dart';
import 'package:backend/repository/repository.dart' show ItemRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


abstract class ItemListBloc<T extends Item, E extends ItemEntity, ID extends Object, R extends ItemRepository<E, ID>> extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc({
    required this.repository,
    required ItemListManagerBloc<T, E, ID, R> managerBloc,
  }) : super(ItemListLoading()) {

    managerSubscription = managerBloc.stream.listen(mapListManagerStateToEvent);

  }

  final R repository;
  late final StreamSubscription<ItemListManagerState> managerSubscription;

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

    } else if(event is UpdateYearView) {

      yield* _mapUpdateYearViewToState(event);

    } else if(event is UpdateSortOrder) {

      yield* _mapUpdateSortOrderToState(event);

    } else if(event is UpdateStyle) {

      yield* _mapUpdateStyleToState(event);

    }

  }

  Stream<ItemListState> _checkConnection() async* {

    if(repository.isClosed()) {
      yield const ItemListNotLoaded('Connection lost. Trying to reconnect');

      try {

        repository.reconnect();
        await repository.open();

      } catch (e) {

        yield ItemListNotLoaded(e.toString());

      }
    }

  }

  Stream<ItemListState> _mapLoadToState() async* {

    yield ItemListLoading();

    try {

      final List<T> items = await getReadAllStream();
      yield ItemListLoaded<T>(items);

    } catch (e) {

      yield ItemListNotLoaded(e.toString());

    }

  }

  Stream<ItemListState> _mapUpdateListToState(UpdateItemList<T> event) async* {

    yield ItemListLoaded<T>(
      event.items,
      event.viewIndex,
      event.year,
      event.style,
    );

  }

  Stream<ItemListState> _mapUpdateItemToState(UpdateListItem<T> event) async* {

    if(state is ItemListLoaded<T>) {
      final List<T> items = List<T>.from((state as ItemListLoaded<T>).items);

      final int listItemIndex = items.indexWhere((T item) => item == event.item);
      final T listItem = items.elementAt(listItemIndex);

      if(listItem != event.item) {
        items[listItemIndex] = event.item;

        final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
        final int year = (state as ItemListLoaded<T>).year;
        final ListStyle style = (state as ItemListLoaded<T>).style;

        yield ItemListLoaded<T>(
          items,
          viewIndex,
          year,
          style,
        );
      }

    }

  }

  Stream<ItemListState> _mapUpdateViewToState(UpdateView event) async* {

    ListStyle? style;
    if(state is ItemListLoaded<T>) {
       style = (state as ItemListLoaded<T>).style;
    }

    yield ItemListLoading();

    try {

      final List<T> items = await getReadViewStream(event);
      yield ItemListLoaded<T>(
        items,
        event.viewIndex,
        null,
        style,
      );

    } catch(e) {

      yield ItemListNotLoaded(e.toString());

    }

  }

  Stream<ItemListState> _mapUpdateYearViewToState(UpdateYearView event) async* {

    ListStyle? style;
    if(state is ItemListLoaded<T>) {
       style = (state as ItemListLoaded<T>).style;
    }

    yield ItemListLoading();

    try {

      final List<T> items = await getReadYearViewStream(event);
      yield ItemListLoaded<T>(
        items,
        event.viewIndex,
        event.year,
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
      final int year = (state as ItemListLoaded<T>).year;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      yield ItemListLoaded<T>(
        reversedItems,
        viewIndex,
        year,
        style,
      );
    }

  }

  Stream<ItemListState> _mapUpdateStyleToState(UpdateStyle event) async* {

    if(state is ItemListLoaded<T>) {
      final int rotatingIndex = ((state as ItemListLoaded<T>).style.index + 1) % ListStyle.values.length;
      final ListStyle updatedStyle = ListStyle.values.elementAt(rotatingIndex);

      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final int year = (state as ItemListLoaded<T>).year;

      yield ItemListLoaded<T>(
        items,
        viewIndex,
        year,
        updatedStyle,
      );
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
      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final int year = (state as ItemListLoaded<T>).year;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final List<T> updatedItems = List<T>.from(items)..add(managerState.item);

      add(UpdateItemList<T>(
        updatedItems,
        viewIndex,
        year,
        style,
      ));
    }

  }

  void _mapDeletedToEvent(ItemDeleted<T> managerState) {

    if(state is ItemListLoaded<T>) {
      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final int year = (state as ItemListLoaded<T>).year;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final List<T> updatedItems = items
          .where((T item) => item != managerState.item)
          .toList(growable: false);

      add(UpdateItemList<T>(
        updatedItems,
        viewIndex,
        year,
        style,
      ));
    }

  }

  @override
  Future<void> close() {

    managerSubscription.cancel();
    return super.close();

  }

  Future<List<T>> getReadAllStream();
  Future<List<T>> getReadViewStream(UpdateView event);
  external Future<List<T>> getReadYearViewStream(UpdateYearView event);
}