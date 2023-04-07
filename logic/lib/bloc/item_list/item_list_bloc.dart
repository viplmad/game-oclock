import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'package:logic/model/model.dart' show ListStyle;
import 'package:logic/service/service.dart' show ItemService;

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
    required this.managerBloc,
  }) : super(ItemListLoading()) {
    on<LoadItemList>(_mapLoadToState);
    on<ReloadItemList>(_mapReloadToState);
    on<UpdateItemList<T>>(_mapUpdateListToState);
    on<UpdateView>(_mapUpdateViewToState);
    on<UpdatePage>(_mapUpdatePageToState);
    on<UpdateStyle>(_mapUpdateStyleToState);

    _managerSubscription =
        managerBloc.stream.listen(_mapListManagerStateToEvent);
  }

  final S service;
  final ItemListManagerBloc<T, N, S> managerBloc;

  late final StreamSubscription<ItemListManagerState> _managerSubscription;

  void _mapLoadToState(LoadItemList event, Emitter<ItemListState> emit) async {
    emit(
      ItemListLoading(),
    );

    try {
      final ViewParameters startViewParameters = await getStartViewIndex();
      final int startViewIndex = startViewParameters.viewIndex;
      final Object? srtartingViewArgs = startViewParameters.viewArgs;

      final List<T> items =
          await getAllWithView(startViewIndex, srtartingViewArgs);

      emit(
        ItemListLoaded<T>(
          items,
          startViewIndex,
          srtartingViewArgs,
        ),
      );
    } catch (e) {
      managerBloc.add(WarnItemListNotLoaded(e.toString()));
      emit(
        ItemListError(),
      );
    }
  }

  void _mapReloadToState(
    ReloadItemList event,
    Emitter<ItemListState> emit,
  ) async {
    emit(
      ItemListLoading(),
    );

    try {
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final Object? viewArgs = (state as ItemListLoaded<T>).viewArgs;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final List<T> items = await getAllWithView(viewIndex, viewArgs);

      emit(
        ItemListLoaded<T>(
          items,
          viewIndex,
          viewArgs,
          0,
          style,
        ),
      );
    } catch (e) {
      managerBloc.add(WarnItemListNotLoaded(e.toString()));
      emit(
        ItemListError(),
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
      final List<T> items =
          await getAllWithView(event.viewIndex, event.viewArgs);
      emit(
        ItemListLoaded<T>(
          items,
          event.viewIndex,
          event.viewArgs,
          0,
          style,
        ),
      );
    } catch (e) {
      managerBloc.add(WarnItemListNotLoaded(e.toString()));
      emit(
        ItemListError(),
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
      final List<T> pageItems = await getAllWithView(viewIndex, viewArgs, page);

      final List<T> updatedItems = List<T>.from(items)..addAll(pageItems);

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

  void _mapListManagerStateToEvent(ItemListManagerState managerState) {
    if (managerState is ItemDeleted<T>) {
      _mapDeletedToEvent(managerState);
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
          .where((T item) => item.id != managerState.item.id)
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
    _managerSubscription.cancel();
    return super.close();
  }

  @protected
  Future<ViewParameters> getStartViewIndex() async {
    return ViewParameters(0);
  }

  @protected
  Future<List<T>> getAllWithView(
    int viewIndex,
    Object? viewArgs, [
    int? page,
  ]);
}
