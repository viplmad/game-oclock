import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/model/list_style.dart';
import 'package:backend/repository/repository.dart' show ItemRepository;

import '../bloc_utils.dart';
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
    on<UpdatePage>(_mapUpdatePageToState);
    on<UpdateStyle>(_mapUpdateStyleToState);

    managerSubscription = managerBloc.stream.listen(mapListManagerStateToEvent);

  }

  final R repository;
  late final StreamSubscription<ItemListManagerState> managerSubscription;

  Future<void> _checkConnection(Emitter<ItemListState> emit) async {

    await BlocUtils.checkConnection<ItemListState, ItemListNotLoaded>(repository, emit, (final String error) => ItemListNotLoaded(error));

  }

  void _mapLoadToState(LoadItemList event, Emitter<ItemListState> emit) async {

    await _checkConnection(emit);

    emit(
      ItemListLoading(),
    );

    try {

      const int page = 0;
      final List<T> items = await getReadAllStream(page);
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
        event.page,
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
        final int? year = (state as ItemListLoaded<T>).year;
        final int page = (state as ItemListLoaded<T>).page;
        final ListStyle style = (state as ItemListLoaded<T>).style;

        emit(
          ItemListLoaded<T>(
            items,
            viewIndex,
            year,
            page,
            style,
          ),
        );
      }

    }

  }

  void _mapUpdateViewToState(UpdateView event, Emitter<ItemListState> emit) async {

    await _checkConnection(emit);

    ListStyle? style;
    if(state is ItemListLoaded<T>) {
       style = (state as ItemListLoaded<T>).style;
    }

    emit(
      ItemListLoading(),
    );

    try {

      const int page = 0;
      final List<T> items = await _getReadViewStream(event, page);
      emit(
        ItemListLoaded<T>(
          items,
          event.viewIndex,
          null,
          page,
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

    await _checkConnection(emit);

    ListStyle? style;
    if(state is ItemListLoaded<T>) {
       style = (state as ItemListLoaded<T>).style;
    }

    emit(
      ItemListLoading(),
    );

    try {

      const int page = 0;
      final List<T> items = await _getReadYearViewStream(event, page);
      emit(
        ItemListLoaded<T>(
          items,
          event.viewIndex,
          event.year,
          page,
          style,
        ),
      );

    } catch(e) {

      emit(
        ItemListNotLoaded(e.toString()),
      );

    }

  }

  void _mapUpdatePageToState(UpdatePage event, Emitter<ItemListState> emit) async {

    if(state is ItemListLoaded<T>) {
      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final int? year = (state as ItemListLoaded<T>).year;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final int page = (state as ItemListLoaded<T>).page + 1;
      List<T> pageItems;
      if(year != null) {
        pageItems = await getReadYearViewStream(viewIndex, year, page);
      } else {
        pageItems = await getReadViewStream(viewIndex, page);
      }

      final List<T> updatedItems = List<T>.from(items)..addAll(pageItems);

      emit(
        ItemListLoaded<T>(
          updatedItems,
          viewIndex,
          year,
          page,
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
      final int? year = (state as ItemListLoaded<T>).year;
      final int page = (state as ItemListLoaded<T>).page;

      emit(
        ItemListLoaded<T>(
          items,
          viewIndex,
          year,
          page,
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
      final int? year = (state as ItemListLoaded<T>).year;
      final int page = (state as ItemListLoaded<T>).page;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final List<T> updatedItems = List<T>.from(items)..add(managerState.item);

      add(UpdateItemList<T>(
        updatedItems,
        viewIndex,
        year,
        page,
        style,
      ));
    }

  }

  void _mapDeletedToEvent(ItemDeleted<T> managerState) {

    if(state is ItemListLoaded<T>) {
      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final int? year = (state as ItemListLoaded<T>).year;
      final int page = (state as ItemListLoaded<T>).page;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final List<T> updatedItems = items
          .where((T item) => item != managerState.item)
          .toList(growable: false);

      add(UpdateItemList<T>(
        updatedItems,
        viewIndex,
        year,
        page,
        style,
      ));
    }

  }

  @override
  Future<void> close() {

    managerSubscription.cancel();
    return super.close();

  }

  Future<List<T>> _getReadViewStream(UpdateView event, int page) => getReadViewStream(event.viewIndex, page);
  Future<List<T>> _getReadYearViewStream(UpdateYearView event, int page) => getReadYearViewStream(event.viewIndex, event.year, page);

  @protected
  Future<List<T>> getReadAllStream([int? page]);
  @protected
  Future<List<T>> getReadViewStream(int viewIndex, [int? page]);
  @protected
  external Future<List<T>> getReadYearViewStream(int viewIndex, int year, [int? page]);
}