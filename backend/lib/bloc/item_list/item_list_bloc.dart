import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show SearchResultDTO, PrimaryModel;

import 'package:backend/model/list_style.dart';
import 'package:backend/service/service.dart' show ItemService;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';

class ViewParameters {
  ViewParameters(this.viewIndex, [this.viewArgs]);

  final int viewIndex;
  final Object? viewArgs;
}

abstract class ItemListBloc<T extends PrimaryModel, N extends Object,
    S extends ItemService<T, N>> extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc({
    required this.service,
    required ItemListManagerBloc<T, N, S> managerBloc,
  }) : super(ItemListLoading()) {
    on<LoadItemList>(_mapLoadToState);
    on<UpdateItemList<T>>(_mapUpdateListToState);
    on<UpdateListItem<T>>(_mapUpdateItemToState);
    on<UpdateView>(_mapUpdateViewToState);
    on<UpdatePage>(_mapUpdatePageToState);
    on<UpdateStyle>(_mapUpdateStyleToState);

    managerSubscription = managerBloc.stream.listen(mapListManagerStateToEvent);
  }

  final S service;
  late final StreamSubscription<ItemListManagerState> managerSubscription;

  void _mapLoadToState(LoadItemList event, Emitter<ItemListState> emit) async {
    emit(
      ItemListLoading(),
    );

    try {
      final ViewParameters startViewParameters = await getStartViewIndex();
      final int startViewIndex = startViewParameters.viewIndex;
      final Object? srtartingViewArgs = startViewParameters.viewArgs;

      final SearchResultDTO<T> items =
          await _getAllWithView(startViewIndex, srtartingViewArgs);

      emit(
        ItemListLoaded<T>(
          items.data,
          startViewIndex,
          srtartingViewArgs,
        ),
      );
    } catch (e) {
      emit(
        ItemListNotLoaded(e.toString()),
      );
    }
  }

  void _mapUpdateListToState(
    UpdateItemList<T> event,
    Emitter<ItemListState> emit,
  ) {
    emit(
      ItemListLoaded<T>(
        event.items,
        event.viewIndex,
        event.viewArgs,
        event.page,
        event.style,
      ),
    );
  }

  void _mapUpdateItemToState(
    UpdateListItem<T> event,
    Emitter<ItemListState> emit,
  ) {
    if (state is ItemListLoaded<T>) {
      final List<T> items = List<T>.from((state as ItemListLoaded<T>).items);

      final int listItemIndex =
          items.indexWhere((T item) => service.sameId(item, event.item));
      final T listItem = items.elementAt(listItemIndex);

      if (listItem != event.item) {
        items[listItemIndex] = event.item;

        final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
        final Object? viewArgs = (state as ItemListLoaded<T>).viewArgs;
        final int page = (state as ItemListLoaded<T>).page;
        final ListStyle style = (state as ItemListLoaded<T>).style;

        emit(
          ItemListLoaded<T>(
            items,
            viewIndex,
            viewArgs,
            page,
            style,
          ),
        );
      }
    }
  }

  void _mapUpdateViewToState(
    UpdateView event,
    Emitter<ItemListState> emit,
  ) async {
    ListStyle? style;
    if (state is ItemListLoaded<T>) {
      style = (state as ItemListLoaded<T>).style;
    }

    emit(
      ItemListLoading(),
    );

    try {
      final SearchResultDTO<T> items =
          await _getAllWithView(event.viewIndex, event.viewArgs);
      emit(
        ItemListLoaded<T>(
          items.data,
          event.viewIndex,
          event.viewArgs,
          0,
          style,
        ),
      );
    } catch (e) {
      emit(
        ItemListNotLoaded(e.toString()),
      );
    }
  }

  void _mapUpdatePageToState(
    UpdatePage event,
    Emitter<ItemListState> emit,
  ) async {
    if (state is ItemListLoaded<T>) {
      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final Object? viewArgs = (state as ItemListLoaded<T>).viewArgs;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final int page = (state as ItemListLoaded<T>).page + 1;
      final SearchResultDTO<T> pageItems =
          await _getAllWithView(viewIndex, viewArgs, page);

      final List<T> updatedItems = List<T>.from(items)..addAll(pageItems.data);

      emit(
        ItemListLoaded<T>(
          updatedItems,
          viewIndex,
          viewArgs,
          page,
          style,
        ),
      );
    }
  }

  void _mapUpdateStyleToState(UpdateStyle event, Emitter<ItemListState> emit) {
    if (state is ItemListLoaded<T>) {
      final int rotatingIndex = ((state as ItemListLoaded<T>).style.index + 1) %
          ListStyle.values.length;
      final ListStyle updatedStyle = ListStyle.values.elementAt(rotatingIndex);

      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final Object? viewArgs = (state as ItemListLoaded<T>).viewArgs;
      final int page = (state as ItemListLoaded<T>).page;

      emit(
        ItemListLoaded<T>(
          items,
          viewIndex,
          viewArgs,
          page,
          updatedStyle,
        ),
      );
    }
  }

  void mapListManagerStateToEvent(ItemListManagerState managerState) {
    if (managerState is ItemAdded<T>) {
      _mapAddedToEvent(managerState);
    } else if (managerState is ItemDeleted<T>) {
      _mapDeletedToEvent(managerState);
    }
  }

  void _mapAddedToEvent(ItemAdded<T> managerState) {
    if (state is ItemListLoaded<T>) {
      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final Object? viewArgs = (state as ItemListLoaded<T>).viewArgs;
      final int page = (state as ItemListLoaded<T>).page;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final List<T> updatedItems = List<T>.from(items)..add(managerState.item);

      add(
        UpdateItemList<T>(
          updatedItems,
          viewIndex,
          viewArgs,
          page,
          style,
        ),
      );
    }
  }

  void _mapDeletedToEvent(ItemDeleted<T> managerState) {
    if (state is ItemListLoaded<T>) {
      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final Object? viewArgs = (state as ItemListLoaded<T>).viewArgs;
      final int page = (state as ItemListLoaded<T>).page;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final List<T> updatedItems = items
          .where((T item) => item != managerState.item)
          .toList(growable: false);

      add(
        UpdateItemList<T>(
          updatedItems,
          viewIndex,
          viewArgs,
          page,
          style,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    managerSubscription.cancel();
    return super.close();
  }

  Future<SearchResultDTO<T>> _getAllWithView(
    int viewIndex,
    Object? viewArgs, [
    int? page,
  ]) {
    return service.getAll(viewIndex, page: page, viewArgs: viewArgs);
  }

  @protected
  Future<ViewParameters> getStartViewIndex();
}
