import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


abstract class ItemDetailBloc<T extends CollectionItem> extends Bloc<ItemDetailEvent, ItemDetailState> {

  ItemDetailBloc({@required this.itemID, @required this.iCollectionRepository});

  final int itemID;
  final ICollectionRepository iCollectionRepository;

  @override
  ItemDetailState get initialState => ItemLoading();

  @override
  Stream<ItemDetailState> mapEventToState(ItemDetailEvent event) async* {

    yield* _checkConnection();

    if(event is LoadItem) {

      yield* _mapLoadToState(event);

    } else if(event is UpdateItem<T>) {

      yield* _mapUpdateToState(event);

    } else if (event is UpdateItemField<T>) {

      yield* _mapUpdateFieldToState(event);

    } else if(event is AddItemImage<T>) {

      yield* _mapAddImageToState(event);

    } else if(event is UpdateItemImageName<T>) {

      yield* _mapUpdateImageNameToState(event);

    } else if(event is DeleteItemImage<T>) {

      yield* _mapDeleteImageToState(event);

    }

  }

  Stream<ItemDetailState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {
      yield ItemNotLoaded("Connection lost. Trying to reconnect");

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<ItemDetailState> _mapLoadToState(LoadItem event) async* {

    yield ItemLoading();

    try {

      final T item = await getReadStream().first;
      yield ItemLoaded<T>(item);

    } catch (e) {

      yield ItemNotLoaded(e.toString());

    }

  }

  Stream<ItemDetailState> _mapUpdateToState(UpdateItem<T> event) async* {

    yield ItemLoaded<T>(event.item);

  }

  Stream<ItemDetailState> _mapUpdateFieldToState(UpdateItemField<T> event) async* {

    try {

      final T updatedItem = await updateFuture(event);

      yield ItemFieldUpdated<T>();

      add(UpdateItem<T>(updatedItem));

    } catch(e) {

      yield ItemFieldNotUpdated(e.toString());

    }
  }

  Stream<ItemDetailState> _mapAddImageToState(AddItemImage<T> event) async* {

    try {

      final T updatedItem = await addImage(event);

      yield ItemImageUpdated<T>();

      add(UpdateItem<T>(updatedItem));

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Stream<ItemDetailState> _mapUpdateImageNameToState(UpdateItemImageName<T> event) async* {

    try {

      final T updatedItem = await updateImageName(event);

      yield ItemImageUpdated<T>();

      add(UpdateItem<T>(updatedItem));

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Stream<ItemDetailState> _mapDeleteImageToState(DeleteItemImage<T> event) async* {

    try {

      final T updatedItem = await deleteImage(event);

      yield ItemImageUpdated<T>();

      add(UpdateItem<T>(updatedItem));

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  @override
  Future<void> close() {

    return super.close();

  }

  external Stream<T> getReadStream();
  external Future<T> updateFuture(UpdateItemField<T> event);
  external Future<T> addImage(AddItemImage<T> event);
  external Future<T> deleteImage(DeleteItemImage<T> event);
  external Future<T> updateImageName(UpdateItemImageName<T> event);

}