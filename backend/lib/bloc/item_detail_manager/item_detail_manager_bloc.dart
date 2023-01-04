import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'package:backend/service/service.dart'
    show ItemService, ItemWithImageService;

import 'item_detail_manager.dart';

abstract class ItemWithImageDetailManagerBloc<T extends PrimaryModel,
        N extends Object, S extends ItemWithImageService<T, N>>
    extends ItemDetailManagerBloc<T, N, S> {
  ItemWithImageDetailManagerBloc({
    required super.itemId,
    required super.service,
  }) {
    on<AddItemImage>(_mapAddImageToState);
    on<UpdateItemImageName>(_mapUpdateImageNameToState);
    on<DeleteItemImage>(_mapDeleteImageToState);
  }

  void _mapAddImageToState(
    AddItemImage event,
    Emitter<ItemDetailManagerState> emit,
  ) async {
    try {
      final T updatedItem = await _addImage(event);
      emit(
        ItemImageUpdated<T>(updatedItem),
      );
    } catch (e) {
      emit(
        ItemImageNotUpdated(e.toString()),
      );
    }

    emit(
      ItemDetailManagerInitialised(),
    );
  }

  void _mapUpdateImageNameToState(
    UpdateItemImageName event,
    Emitter<ItemDetailManagerState> emit,
  ) async {
    try {
      final T updatedItem = await _updateImageName(event);
      emit(
        ItemImageUpdated<T>(updatedItem),
      );
    } catch (e) {
      emit(
        ItemImageNotUpdated(e.toString()),
      );
    }

    emit(
      ItemDetailManagerInitialised(),
    );
  }

  void _mapDeleteImageToState(
    DeleteItemImage event,
    Emitter<ItemDetailManagerState> emit,
  ) async {
    try {
      final T updatedItem = await _deleteImage(event);
      emit(
        ItemImageUpdated<T>(updatedItem),
      );
    } catch (e) {
      emit(
        ItemImageNotUpdated(e.toString()),
      );
    }

    emit(
      ItemDetailManagerInitialised(),
    );
  }

  Future<T> _addImage(AddItemImage event) async {
    await service.uploadImage(itemId, event.imagePath);
    return service.get(itemId);
  }

  Future<T> _updateImageName(UpdateItemImageName event) async {
    await service.renameImage(itemId, event.oldImageName, event.newImageName);
    return service.get(itemId);
  }

  Future<T> _deleteImage(DeleteItemImage event) async {
    await service.deleteImage(itemId, event.imageName);
    return service.get(itemId);
  }
}

abstract class ItemDetailManagerBloc<T extends PrimaryModel, N extends Object,
        S extends ItemService<T, N>>
    extends Bloc<ItemDetailManagerEvent, ItemDetailManagerState> {
  ItemDetailManagerBloc({
    required this.itemId,
    required this.service,
  }) : super(ItemDetailManagerInitialised()) {
    on<UpdateItemField<N>>(_mapUpdateFieldToState);
  }

  final int itemId;
  final S service;

  void _mapUpdateFieldToState(
    UpdateItemField<N> event,
    Emitter<ItemDetailManagerState> emit,
  ) async {
    try {
      final T updatedItem = await _update(event);
      emit(
        ItemFieldUpdated<T>(updatedItem),
      );
    } catch (e) {
      emit(
        ItemFieldNotUpdated(e.toString()),
      );
    }

    emit(
      ItemDetailManagerInitialised(),
    );
  }

  Future<T> _update(UpdateItemField<N> event) {
    return service.update(itemId, event.item);
  }
}
