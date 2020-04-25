import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


abstract class ItemDetailBloc extends Bloc<ItemDetailEvent, ItemDetailState> {

  ItemDetailBloc({@required this.itemBloc}) {
    itemSubscription = itemBloc.listen( _mapItemStateToEvent );
  }

  final ItemBloc itemBloc;
  StreamSubscription<ItemState> itemSubscription;
  ICollectionRepository get collectionRepository => itemBloc.collectionRepository;

  @override
  ItemDetailState get initialState => ItemLoading();

  @override
  Stream<ItemDetailState> mapEventToState(ItemDetailEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItem) {

      yield* _mapLoadToState(event);

    } else if(event is UpdateItem) {

      yield* _mapUpdateToState(event);

    }

  }

  Stream<ItemDetailState> _checkConnection() async* {

    if(collectionRepository.isClosed()) {
      yield ItemNotLoaded("Connection lost. Trying to reconnect");

      try {

        collectionRepository.reconnect();
        await collectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<ItemDetailState> _mapLoadToState(LoadItem event) async* {

    yield ItemLoading();

    try {

      final CollectionItem item = await getReadIDStream(event).first;
      yield ItemLoaded(item);

    } catch (e) {

      yield ItemNotLoaded(e.toString());

    }

  }

  Stream<ItemDetailState> _mapUpdateToState(UpdateItem event) async* {

    yield ItemLoaded(event.item);

  }

  void _mapItemStateToEvent(ItemState itemState) {

    if(itemState is ItemFieldUpdated) {

      _mapUpdatedFieldToEvent(itemState);

    } else if(itemState is ItemImageUpdated) {

      _mapUpdatedImageToEvent(itemState);

    }

  }

  void _mapUpdatedFieldToEvent(ItemFieldUpdated itemState) {

    if(state is ItemLoaded) {
      final CollectionItem itemUpdated = itemState.item;

      add(UpdateItem(itemUpdated));
    }

  }

  void _mapUpdatedImageToEvent(ItemImageUpdated itemState) {

    if(state is ItemLoaded) {
      final CollectionItem itemUpdated = itemState.item;

      add(UpdateItem(itemUpdated));
    }

  }

  @override
  Future<void> close() {

    itemSubscription?.cancel();
    return super.close();

  }

  external Stream<CollectionItem> getReadIDStream(LoadItem event);

}