import 'dart:async';

import 'package:meta/meta.dart';
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

    on<LoadItemList>(_mapLoadToState);
    on<UpdateItemList<T>>(_mapUpdateListToState);
    on<UpdateListItem<T>>(_mapUpdateItemToState);
    on<UpdateView>(_mapUpdateViewToState);
    on<UpdateYearView>(_mapUpdateYearViewToState);
    on<UpdateSortOrder>(_mapUpdateSortOrderToState);
    on<UpdateStyle>(_mapUpdateStyleToState);

    managerSubscription = managerBloc.stream.listen(mapListManagerStateToEvent);

  }

  final R repository;
  late final StreamSubscription<ItemListManagerState> managerSubscription;

  void _checkConnection(Emitter<ItemListState> emit) async {

    if(repository.isClosed()) {
      emit(
        const ItemListNotLoaded('Connection lost. Trying to reconnect'),
      );

      try {

        repository.reconnect();
        await repository.open();

      } catch (e) {

        emit(
          ItemListNotLoaded(e.toString()),
        );

      }
    }

  }

  void _mapLoadToState(LoadItemList event, Emitter<ItemListState> emit) async {

    _checkConnection(emit);

    emit(
      ItemListLoading(),
    );

    try {

      final List<T> items = await getReadAllStream();
      emit(
        ItemListLoaded<T>(items),
      );

    } catch (e) {

      emit(
        ItemListNotLoaded(e.toString()),
      );

    }

  }

  void _mapUpdateListToState(UpdateItemList<T> event, Emitter<ItemListState> emit) {

    emit(
      ItemListLoaded<T>(
        event.items,
        event.viewIndex,
        event.year,
        event.style,
      ),
    );

  }

  void _mapUpdateItemToState(UpdateListItem<T> event, Emitter<ItemListState> emit) {

    if(state is ItemListLoaded<T>) {
      final List<T> items = List<T>.from((state as ItemListLoaded<T>).items);

      final int listItemIndex = items.indexWhere((T item) => item.uniqueId == event.item.uniqueId);
      final T listItem = items.elementAt(listItemIndex);

      if(listItem != event.item) {
        items[listItemIndex] = event.item;

        final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
        final int year = (state as ItemListLoaded<T>).year;
        final ListStyle style = (state as ItemListLoaded<T>).style;

        emit(
          ItemListLoaded<T>(
            items,
            viewIndex,
            year,
            style,
          ),
        );
      }

    }

  }

  void _mapUpdateViewToState(UpdateView event, Emitter<ItemListState> emit) async {

    _checkConnection(emit);

    ListStyle? style;
    if(state is ItemListLoaded<T>) {
       style = (state as ItemListLoaded<T>).style;
    }

    emit(
      ItemListLoading(),
    );

    try {

      final List<T> items = await getReadViewStream(event);
      emit(
        ItemListLoaded<T>(
          items,
          event.viewIndex,
          null,
          style,
        ),
      );

    } catch(e) {

      emit(
        ItemListNotLoaded(e.toString()),
      );

    }

  }

  void _mapUpdateYearViewToState(UpdateYearView event, Emitter<ItemListState> emit) async {

    _checkConnection(emit);

    ListStyle? style;
    if(state is ItemListLoaded<T>) {
       style = (state as ItemListLoaded<T>).style;
    }

    emit(
      ItemListLoading(),
    );

    try {

      final List<T> items = await getReadYearViewStream(event);
      emit(
        ItemListLoaded<T>(
          items,
          event.viewIndex,
          event.year,
          style,
        ),
      );

    } catch(e) {

      emit(
        ItemListNotLoaded(e.toString()),
      );

    }

  }

  void _mapUpdateSortOrderToState(UpdateSortOrder event, Emitter<ItemListState> emit) {

    if(state is ItemListLoaded<T>) {
      final List<T> reversedItems = (state as ItemListLoaded<T>).items.reversed.toList(growable: false);

      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final int year = (state as ItemListLoaded<T>).year;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      emit(
        ItemListLoaded<T>(
          reversedItems,
          viewIndex,
          year,
          style,
        ),
      );
    }

  }

  void _mapUpdateStyleToState(UpdateStyle event, Emitter<ItemListState> emit) {

    if(state is ItemListLoaded<T>) {
      final int rotatingIndex = ((state as ItemListLoaded<T>).style.index + 1) % ListStyle.values.length;
      final ListStyle updatedStyle = ListStyle.values.elementAt(rotatingIndex);

      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final int year = (state as ItemListLoaded<T>).year;

      emit(
        ItemListLoaded<T>(
          items,
          viewIndex,
          year,
          updatedStyle,
        ),
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

  @protected
  Future<List<T>> getReadAllStream();
  @protected
  Future<List<T>> getReadViewStream(UpdateView event);
  @protected
  external Future<List<T>> getReadYearViewStream(UpdateYearView event);
}