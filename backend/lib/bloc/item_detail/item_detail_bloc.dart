import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


abstract class ItemDetailBloc<T extends CollectionItem, P extends Object> extends Bloc<ItemDetailEvent, ItemDetailState> {
  ItemDetailBloc({
    required this.itemId,
    required this.iCollectionRepository,
    required this.managerBloc,
  }) : super(ItemLoading()) {

    managerSubscription = managerBloc.stream.listen(_mapDetailManagerStateToEvent);

  }

  final int itemId;
  final CollectionRepository iCollectionRepository;
  final ItemDetailManagerBloc<T, P> managerBloc;
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

    if(iCollectionRepository.isClosed()) {
      yield const ItemNotLoaded('Connection lost. Trying to reconnect');

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

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

      final T? item = await getReadStream().first;
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

  Stream<T?> getReadStream();
}