import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/entity/entity.dart' show ItemEntity;
import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart' show ItemRepository;

import 'item_detail_manager.dart';


abstract class ItemDetailManagerBloc<T extends Item, E extends ItemEntity, ID extends Object, R extends ItemRepository<E, ID>> extends Bloc<ItemDetailManagerEvent, ItemDetailManagerState> {
  ItemDetailManagerBloc({
    required this.id,
    required this.repository,
  }) : super(ItemDetailManagerInitialised()) {

    on<UpdateItemField<T>>(_mapUpdateFieldToState);
    on<AddItemImage<T>>(_mapAddImageToState);
    on<UpdateItemImageName<T>>(_mapUpdateImageNameToState);
    on<DeleteItemImage<T>>(_mapDeleteImageToState);

  }

  final ID id;
  final R repository;

  void _checkConnection(Emitter<ItemDetailManagerState> emit) async {

    if(repository.isClosed()) {

      try {

        repository.reconnect();
        await repository.open();

      } catch(e) {

        emit(
          ItemFieldNotUpdated(e.toString()),
        );

      }
    }

  }

  void _mapUpdateFieldToState(UpdateItemField<T> event, Emitter<ItemDetailManagerState> emit) async {

    _checkConnection(emit);

    try {

      if(event.item != event.updatedItem) {
        final T updatedItem = await updateFuture(event);
        emit(
          ItemFieldUpdated<T>(updatedItem),
        );
      }

    } catch(e) {

      emit(
        ItemFieldNotUpdated(e.toString()),
      );

    }

    emit(
      ItemDetailManagerInitialised(),
    );

  }

  void _mapAddImageToState(AddItemImage<T> event, Emitter<ItemDetailManagerState> emit) async {

    _checkConnection(emit);

    try {

      final T updatedItem = await addImage(event);
      emit(
        ItemImageUpdated<T>(updatedItem),
      );

    } catch(e) {

      emit(
        ItemImageNotUpdated(e.toString()),
      );

    }

    emit(
      ItemDetailManagerInitialised(),
    );

  }

  void _mapUpdateImageNameToState(UpdateItemImageName<T> event, Emitter<ItemDetailManagerState> emit) async {

    _checkConnection(emit);

    try {

      final T updatedItem = await updateImageName(event);
      emit(
        ItemImageUpdated<T>(updatedItem),)
      ;

    } catch(e) {

      emit(
        ItemImageNotUpdated(e.toString()),
      );

    }

    emit(
      ItemDetailManagerInitialised(),
    );

  }

  void _mapDeleteImageToState(DeleteItemImage<T> event, Emitter<ItemDetailManagerState> emit) async {

    _checkConnection(emit);

    try {

      final T updatedItem = await deleteImage(event);
      emit(
        ItemImageUpdated<T>(updatedItem),
      );

    } catch(e) {

      emit(
        ItemImageNotUpdated(e.toString()),
      );

    }

    emit(
      ItemDetailManagerInitialised(),
    );

  }

  @protected
  Future<T> updateFuture(UpdateItemField<T> event) ;
  @protected
  external Future<T> addImage(AddItemImage<T> event);
  @protected
  external Future<T> deleteImage(DeleteItemImage<T> event);
  @protected
  external Future<T> updateImageName(UpdateItemImageName<T> event);
}