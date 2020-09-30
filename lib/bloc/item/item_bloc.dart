import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


abstract class ItemBloc<T extends CollectionItem> extends Bloc<ItemEvent, ItemState> {

  ItemBloc({@required this.collectionRepository});

  final ICollectionRepository collectionRepository;

  @override
  ItemState get initialState => Rested();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {

    yield* _checkConnection();

    if(event is AddItem) {

      yield* _mapAddToState(event);

    } else if(event is DeleteItem<T>) {

      yield* _mapDeleteToState(event);

    } else if(event is UpdateItemField<T>) {

      yield* _mapUpdateFieldToState(event);

    } else if(event is AddItemImage<T>) {

      yield* _mapAddImageToState(event);

    } else if(event is UpdateItemImageName<T>) {

      yield* _mapUpdateImageNameToState(event);

    } else if(event is DeleteItemImage<T>) {

      yield* _mapDeleteImageToState(event);

    } else if(event is AddItemRelation) {

      yield* _mapAddRelationToState(event);

    } else if(event is DeleteItemRelation) {

      yield* _mapDeleteRelationToState(event);

    }

    yield Rested();

  }

  Stream<ItemState> _checkConnection() async* {

    if(collectionRepository.isClosed()) {

      try {

        collectionRepository.reconnect();
        await collectionRepository.open();

      } catch(e) {
      }

    }

  }

  Stream<ItemState> _mapAddToState(AddItem event) async* {

    try {

      final T item = await createFuture(event);
      yield ItemAdded<T>(item);

    } catch (e) {

      yield ItemNotAdded(e.toString());

    }

  }

  Stream<ItemState> _mapDeleteToState(DeleteItem<T> event) async* {

    try {

      await deleteFuture(event);
      yield ItemDeleted<T>(event.item);

    } catch (e) {

      yield ItemNotDeleted(e.toString());

    }

  }

  Stream<ItemState> _mapUpdateFieldToState(UpdateItemField<T> event) async* {

    try {

      final T updatedItem = await updateFuture(event);
      yield ItemFieldUpdated<T>(updatedItem);

    } catch(e) {

      yield ItemFieldNotUpdated(e.toString());

    }
  }

  Stream<ItemState> _mapAddImageToState(AddItemImage<T> event) async* {

    try {

      final T updatedItem = await addImage(event);
      yield ItemImageUpdated<T>(updatedItem);

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Stream<ItemState> _mapUpdateImageNameToState(UpdateItemImageName<T> event) async* {

    try {

      final T updatedItem = await updateImageName(event);
      yield ItemImageUpdated<T>(updatedItem);

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Stream<ItemState> _mapDeleteImageToState(DeleteItemImage<T> event) async* {

    try {

      final T updatedItem = await deleteImage(event);
      yield ItemImageUpdated<T>(updatedItem);

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Stream<ItemState> _mapAddRelationToState<W extends CollectionItem>(AddItemRelation<T, W> event) async* {

    try{

      await addRelationFuture<W>(event);
      yield ItemRelationAdded<W>(
        event.otherItem,
      );

    } catch(e) {

      yield ItemRelationNotAdded(e);

    }

  }

  Stream<ItemState> _mapDeleteRelationToState<W extends CollectionItem>(DeleteItemRelation<T, W> event) async* {

    try{

      await deleteRelationFuture<W>(event);
      yield ItemRelationDeleted<W>(
        event.otherItem,
      );

    } catch(e) {

      yield ItemRelationNotDeleted(e);

    }

  }

  @override
  Future<void> close() {

    return super.close();

  }

  external Future<T> createFuture(AddItem event);
  external Future<dynamic> deleteFuture(DeleteItem<T> event);
  external Future<T> updateFuture(UpdateItemField<T> event);
  external Future<T> addImage(AddItemImage<T> event);
  external Future<T> deleteImage(DeleteItemImage<T> event);
  external Future<T> updateImageName(UpdateItemImageName<T> event);
  @mustCallSuper
  Future<dynamic> addRelationFuture<W extends CollectionItem>(AddItemRelation<T, W> event) {

    return Future.error("Relation does not exist");

  }
  @mustCallSuper
  Future<dynamic> deleteRelationFuture<W extends CollectionItem>(DeleteItemRelation<T, W> event) {

    return Future.error("Relation does not exist");

  }

}