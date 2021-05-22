import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_detail_manager.dart';

abstract class ItemDetailManagerBloc<T extends CollectionItem, P extends Object> extends Bloc<ItemDetailManagerEvent, ItemDetailManagerState> {
  ItemDetailManagerBloc({
    required this.itemId,
    required this.iCollectionRepository,
  }) : super(ItemDetailManagerInitialised());

  final int itemId;
  final ICollectionRepository iCollectionRepository;

  @override
  Stream<ItemDetailManagerState> mapEventToState(ItemDetailManagerEvent event) async* {

    yield* _checkConnection();

    if(event is UpdateItemField<T, P>) {

      yield* _mapUpdateFieldToState(event);

    } else if(event is AddItemImage<T>) {

      yield* _mapAddImageToState(event);

    } else if(event is UpdateItemImageName<T>) {

      yield* _mapUpdateImageNameToState(event);

    } else if(event is DeleteItemImage<T>) {

      yield* _mapDeleteImageToState(event);

    }

    yield ItemDetailManagerInitialised();

  }

  Stream<ItemDetailManagerState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch(e) {

        yield ItemFieldNotUpdated(e.toString());

      }
    }

  }

  Stream<ItemDetailManagerState> _mapUpdateFieldToState(UpdateItemField<T, P> event) async* {

    try {

      final T? updatedItem = await updateFuture(event);
      if(updatedItem != null) {
        yield ItemFieldUpdated<T>(updatedItem);
      } else {
        throw Exception();
      }

    } catch(e) {

      yield ItemFieldNotUpdated(e.toString());

    }

  }

  Stream<ItemDetailManagerState> _mapAddImageToState(AddItemImage<T> event) async* {

    try {

      final T? updatedItem = await addImage(event);
      if(updatedItem != null) {
        yield ItemImageUpdated<T>(updatedItem);
      } else {
        throw Exception();
      }

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Stream<ItemDetailManagerState> _mapUpdateImageNameToState(UpdateItemImageName<T> event) async* {

    try {

      final T? updatedItem = await updateImageName(event);
      if(updatedItem != null) {
        yield ItemImageUpdated<T>(updatedItem);
      } else {
        throw Exception();
      }

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Stream<ItemDetailManagerState> _mapDeleteImageToState(DeleteItemImage<T> event) async* {

    try {

      final T? updatedItem = await deleteImage(event);
      if(updatedItem != null) {
        yield ItemImageUpdated<T>(updatedItem);
      } else {
        throw Exception();
      }

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Future<T?> updateFuture(UpdateItemField<T, P> event);
  external Future<T?> addImage(AddItemImage<T> event);
  external Future<T?> deleteImage(DeleteItemImage<T> event);
  external Future<T?> updateImageName(UpdateItemImageName<T> event);
}