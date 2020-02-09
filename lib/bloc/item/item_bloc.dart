import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

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

    } else if(event is UpdateItemField) {

      yield* _mapUpdateFieldToState(event);

    } else if(event is AddItemRelation) {

      yield* _mapAddRelationToState(event);

    } else if(event is DeleteItemRelation) {

      yield* _mapDeleteRelationToState(event);

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

      await deleteFuture(event);
      yield ItemDeleted(event.item);

    } catch (e) {

      yield ItemNotDeleted(e.toString());

    }

  }

  Stream<ItemState> _mapUpdateFieldToState(UpdateItemField event) async* {

    try {

      final CollectionItem item = await updateFuture(event);
      yield ItemFieldUpdated(item);

    } catch(e) {

      yield ItemFieldNotUpdated(e.toString());

    }
  }

  Stream<ItemState> _mapAddRelationToState(AddItemRelation event) async* {

    try{

      await addRelationFuture(event);
      yield ItemRelationAdded(
        event.otherItem,
        event.field,
      );

    } catch(e) {

      yield ItemRelationNotAdded(e);

    }

  }

  Stream<ItemState> _mapDeleteRelationToState(DeleteItemRelation event) async* {

    try{

      await deleteRelationFuture(event);
      yield ItemRelationDeleted(
        event.otherItem,
        event.field,
      );

    } catch(e) {

      yield ItemRelationNotDeleted(e);

    }

  }

  @override
  Future<void> close() {

    return super.close();

  }

  external Future<CollectionItem> createFuture();
  external Future<dynamic> deleteFuture(DeleteItem event);
  external Future<CollectionItem> updateFuture(UpdateItemField event);
  external Future<dynamic> addRelationFuture(AddItemRelation event);
  external Future<dynamic> deleteRelationFuture(DeleteItemRelation event);

}