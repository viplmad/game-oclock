import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


abstract class ItemDetailBloc<T extends Item, E extends ItemEntity, ID extends Object, R extends ItemRepository<E, ID>> extends Bloc<ItemDetailEvent, ItemDetailState> {
  ItemDetailBloc({
    required this.id,
    required this.repository,
    required this.managerBloc,
  }) : super(ItemLoading()) {

    managerSubscription = managerBloc.stream.listen(_mapDetailManagerStateToEvent);

  }

  final ID id;
  final R repository;
  final ItemDetailManagerBloc<T, E, ID, R> managerBloc;
  late StreamSubscription<ItemDetailManagerState> managerSubscription;

  @override
  Stream<ItemDetailState> mapEventToState(ItemDetailEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItem) {

      yield* _mapLoadToState(event);

    } else if(event is ReloadItem) {

      yield* _mapReloadToState(event);

    } else if(event is UpdateItem<T>) {

      yield* _mapUpdateToState(event);

    }

  }

  Stream<ItemDetailState> _checkConnection() async* {

    if(repository.isClosed()) {
      yield const ItemNotLoaded('Connection lost. Trying to reconnect');

      try {

        repository.reconnect();
        await repository.open();

      } catch (e) {

        yield ItemNotLoaded(e.toString());

      }
    }

  }

  Stream<ItemDetailState> _mapLoadToState(LoadItem event) async* {

    yield ItemLoading();

    yield* _mapAnyLoadToState();

  }

  Stream<ItemDetailState> _mapReloadToState(ReloadItem event) async* {

    yield* _mapAnyLoadToState();

  }

  Stream<ItemDetailState> _mapAnyLoadToState() async* {

    try {

      final T? item = await getReadFuture();
      if(item != null) {
        yield ItemLoaded<T>(item);
      } else {
        throw Exception();
      }

    } catch (e) {

      yield ItemNotLoaded(e.toString());

    }

  }

  Stream<ItemDetailState> _mapUpdateToState(UpdateItem<T> event) async* {

    yield ItemLoaded<T>(event.item);

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

  Future<T> getReadFuture();
}