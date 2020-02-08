import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';

abstract class ItemDetailBloc extends Bloc<ItemDetailEvent, ItemDetailState> {

  ItemDetailBloc({@required this.itemBloc}) {
    itemSubscription = itemBloc.listen( mapItemStateToEvent );
  }

  final ItemBloc itemBloc;
  StreamSubscription<ItemState> itemSubscription;
  ICollectionRepository get collectionRepository => itemBloc.collectionRepository;

  @override
  ItemDetailState get initialState => ItemLoading();

  @override
  Stream<ItemDetailState> mapEventToState(ItemDetailEvent event) async* {

    if(event is LoadItem) {

      yield* _mapLoadToState(event);

    } else if(event is UpdateItem) {

      yield* _mapUpdateToState(event);

    }

  }

  Stream<ItemDetailState> _mapLoadToState(LoadItem event) async* {

    yield ItemLoading();

    try {

      final CollectionItem item = await getReadIDStream(event.ID).first;
      yield ItemLoaded(item);

    } catch (e) {

      yield ItemNotLoaded(e.toString());

    }

  }

  Stream<ItemDetailState> _mapUpdateToState(UpdateItem event) async* {

    yield ItemLoaded(event.item);

  }

  void mapItemStateToEvent(ItemState itemState) {

    if(itemState is ItemFieldUpdated) {

      _mapUpdatedToEvent(itemState);

    }

  }

  void _mapUpdatedToEvent(ItemFieldUpdated itemState) {

    if(state is ItemLoaded) {
      final itemUpdated = itemState.item;

      add(UpdateItem(itemUpdated));
    }

  }

  @override
  Future<void> close() {

    itemSubscription?.cancel();
    return super.close();

  }

  external Stream<CollectionItem> getReadIDStream(int ID);

}