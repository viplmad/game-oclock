import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import '../bloc_utils.dart';
import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


abstract class ItemDetailBloc<T extends Item, E extends ItemEntity, ID extends Object, R extends ItemRepository<E, ID>> extends Bloc<ItemDetailEvent, ItemDetailState> {
  ItemDetailBloc({
    required this.id,
    required this.repository,
    required this.managerBloc,
  }) : super(ItemLoading()) {

    on<LoadItem>(_mapLoadToState);
    on<ReloadItem>(_mapReloadToState);
    on<UpdateItem<T>>(_mapUpdateToState);

    managerSubscription = managerBloc.stream.listen(_mapDetailManagerStateToEvent);

  }

  final ID id;
  final R repository;
  final ItemDetailManagerBloc<T, E, ID, R> managerBloc;
  late StreamSubscription<ItemDetailManagerState> managerSubscription;

  void _checkConnection(Emitter<ItemDetailState> emit) async {

    await BlocUtils.checkConnection<R, ItemDetailState, ItemNotLoaded>(repository, emit, (final String error) => ItemNotLoaded(error));

  }

  void _mapLoadToState(LoadItem event, Emitter<ItemDetailState> emit) {

    emit(
      ItemLoading(),
    );

    _mapAnyLoadToState(emit);

  }

  void _mapReloadToState(ReloadItem event, Emitter<ItemDetailState> emit) {

    _mapAnyLoadToState(emit);

  }

  void _mapAnyLoadToState(Emitter<ItemDetailState> emit) async {

    _checkConnection(emit);

    try {

      final T item = await getReadFuture();
      emit(
        ItemLoaded<T>(item),
      );

    } catch (e) {

      emit(
        ItemNotLoaded(e.toString()),
      );

    }

  }

  void _mapUpdateToState(UpdateItem<T> event,Emitter<ItemDetailState> emit) {

    emit(
      ItemLoaded<T>(event.item),
    );

  }

  void _mapDetailManagerStateToEvent(ItemDetailManagerState managerState) {

    if(managerState is ItemFieldUpdated<T>) {

      _mapFieldUpdatedToEvent(managerState);

    } else if(managerState is ItemImageUpdated<T>) {

      _mapImageUpdatedToEvent(managerState);

    }

  }

  void _mapFieldUpdatedToEvent(ItemFieldUpdated<T> event) {

    add(UpdateItem<T>(event.item));

  }

  void _mapImageUpdatedToEvent(ItemImageUpdated<T> event) {

    add(UpdateItem<T>(event.item));

  }

  @override
  Future<void> close() {

    managerSubscription.cancel();
    return super.close();

  }

  @protected
  Future<T> getReadFuture();
}