import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';

import 'item.dart';

abstract class ItemBloc extends Bloc<ItemEvent, ItemState> {

  ItemBloc({@required this.collectionRepository});

  final ICollectionRepository collectionRepository;

  @override
  ItemState get initialState => Rested();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {

    if(event is AddItem) {

      yield* _mapAddToState(event);

    } else if(event is DeleteItem) {

      yield* _mapDeleteToState(event);

    } else if(event is UpdateItem) {

      yield* _mapUpdateToState(event);

    }

    yield Rested();

  }

  Stream<ItemState> _mapAddToState(AddItem event) async* {

    try {

      final CollectionItem item = await createFuture();
      yield ItemAdded(item);

    } catch (e) {

      yield ItemNotAdded(e.toString());

    }

  }

  Stream<ItemState> _mapDeleteToState(DeleteItem event) async* {

    try {

      await deleteFuture(event.item);
      yield ItemDeleted(event.item);

    } catch (e) {

      yield ItemNotDeleted(e.toString());

    }

  }

  Stream<ItemState> _mapUpdateToState(UpdateItem event) async* {

  }

  @override
  Future<void> close() {

    return super.close();

  }

  external Future<CollectionItem> createFuture();
  external Future<dynamic> deleteFuture(CollectionItem item);
  external Future<dynamic> updateFuture();

}