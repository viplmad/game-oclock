import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode, PrimaryModel;

import 'package:logic/model/model.dart' show ListStyle;
import 'package:logic/service/service.dart' show ItemService;
import 'package:logic/bloc/bloc_utils.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';

abstract class ItemListBloc<T extends PrimaryModel, N extends Object,
    S extends ItemService<T, N>> extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc({
    required this.service,
    required this.managerBloc,
  }) : super(ItemListLoading()) {
    on<LoadItemList>(_mapLoadToState);
    on<ReloadItemList>(_mapReloadToState);
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

    await _mapAnyLoadToState(emit);
  }

  void _mapReloadToState(
    ReloadItemList event,
    Emitter<ItemListState> emit,
  ) async {
    if (state is ItemListLoaded<T>) {
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      if (!event.silent) {
        emit(
          ItemListLoading(),
        );
      }

      try {
        final List<T> items = await getAllWithView(viewIndex);

        emit(
          ItemListLoaded<T>(
            items,
            viewIndex,
            0,
            style,
          ),
        );
      } catch (e) {
        _handleError(e, emit);
      }
    } else if (state is! ItemListLoading) {
      await _mapAnyLoadToState(emit);
    }
  }

  Future<void> _mapAnyLoadToState(Emitter<ItemListState> emit) async {
    try {
      final int startViewIndex = await getStartViewIndex();

      final List<T> items = await getAllWithView(startViewIndex);

      emit(
        ItemListLoaded<T>(
          items,
          startViewIndex,
        ),
      );
    } catch (e) {
      _handleError(e, emit);
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
      final List<T> items = await getAllWithView(event.viewIndex);
      emit(
        ItemListLoaded<T>(
          items,
          event.viewIndex,
          0,
          style,
        ),
      );
    } catch (e) {
      _handleError(e, emit);
    }
  }

  void _mapUpdatePageToState(
    UpdatePage event,
    Emitter<ItemListState> emit,
  ) async {
    if (state is ItemListLoaded<T>) {
      final List<T> items = (state as ItemListLoaded<T>).items;
      final int viewIndex = (state as ItemListLoaded<T>).viewIndex;
      final ListStyle style = (state as ItemListLoaded<T>).style;

      final int page = (state as ItemListLoaded<T>).page + 1;
      final List<T> pageItems = await getAllWithView(viewIndex, page);

      final List<T> updatedItems = List<T>.from(items)..addAll(pageItems);

      emit(
        ItemListLoaded<T>(
          updatedItems,
          viewIndex,
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
      final int page = (state as ItemListLoaded<T>).page;

      emit(
        ItemListLoaded<T>(
          items,
          viewIndex,
          page,
          updatedStyle,
        ),
      );
    }
  }

  void _handleError(Object e, Emitter<ItemListState> emit) {
    BlocUtils.handleErrorWithManager(
      e,
      emit,
      managerBloc,
      () => ItemListError(),
      (ErrorCode error, String errorDescription) =>
          WarnItemListNotLoaded(error, errorDescription),
    );
  }

  void _mapListManagerStateToEvent(ItemListManagerState managerState) {
    if (managerState is ItemAdded<T>) {
      _mapAddedToEvent(managerState);
    } else if (managerState is ItemDeleted<T>) {
      _mapDeletedToEvent(managerState);
    }
  }

  void _mapAddedToEvent(ItemAdded<T> managerState) {
    add(const ReloadItemList(silent: true));
  }

  void _mapDeletedToEvent(ItemDeleted<T> managerState) {
    add(const ReloadItemList(silent: true));
  }

  @override
  Future<void> close() {
    _managerSubscription.cancel();
    return super.close();
  }

  @protected
  Future<int> getStartViewIndex() async {
    return 0;
  }

  @protected
  Future<List<T>> getAllWithView(
    int viewIndex, [
    int? page,
  ]);
}
