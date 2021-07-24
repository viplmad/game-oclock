import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import 'item_detail_manager.dart';


abstract class ItemDetailManagerBloc<T extends Item, E extends ItemEntity, ID extends Object, R extends ItemRepository<E, ID>> extends Bloc<ItemDetailManagerEvent, ItemDetailManagerState> {
  ItemDetailManagerBloc({
    required this.id,
    required this.repository,
  }) : super(ItemDetailManagerInitialised());

  final ID id;
  final R repository;

  @override
  Stream<ItemDetailManagerState> mapEventToState(ItemDetailManagerEvent event) async* {

    yield* _checkConnection();

    if(event is UpdateItemField<T>) {

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

    if(repository.isClosed()) {

      try {

        repository.reconnect();
        await repository.open();

      } catch(e) {

        yield ItemFieldNotUpdated(e.toString());

      }
    }

  }

  Stream<ItemDetailManagerState> _mapUpdateFieldToState(UpdateItemField<T> event) async* {

    try {

      final T updatedItem = await updateFuture(event);
      yield ItemFieldUpdated<T>(updatedItem);

    } catch(e) {

      yield ItemFieldNotUpdated(e.toString());

    }

  }

  Stream<ItemDetailManagerState> _mapAddImageToState(AddItemImage<T> event) async* {

    try {

      final T updatedItem = await addImage(event);
      yield ItemImageUpdated<T>(updatedItem);

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Stream<ItemDetailManagerState> _mapUpdateImageNameToState(UpdateItemImageName<T> event) async* {

    try {

      final T updatedItem = await updateImageName(event);
      yield ItemImageUpdated<T>(updatedItem);

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Stream<ItemDetailManagerState> _mapDeleteImageToState(DeleteItemImage<T> event) async* {

    try {

      final T updatedItem = await deleteImage(event);
      yield ItemImageUpdated<T>(updatedItem);

    } catch(e) {

      yield ItemImageNotUpdated(e.toString());

    }

  }

  Future<T> updateFuture(UpdateItemField<T> event) ;
  external Future<T> addImage(AddItemImage<T> event);
  external Future<T> deleteImage(DeleteItemImage<T> event);
  external Future<T> updateImageName(UpdateItemImageName<T> event);
}