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
    on<SetItemImage>(_mapSetImageToState);
    on<UpdateItemImageName>(_mapUpdateImageNameToState);
    on<DeleteItemImage>(_mapDeleteImageToState);
  }

  void _mapSetImageToState(
    SetItemImage event,
    Emitter<ItemDetailManagerState> emit,
  ) async {
    try {
      await _setImage(event);
      emit(
        ItemImageUpdated(),
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
      await _updateImageName(event);
      emit(
        ItemImageUpdated(),
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
      await _deleteImage(event);
      emit(
        ItemImageUpdated(),
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

  Future<void> _setImage(SetItemImage event) async {
    return service.uploadImage(itemId, event.imagePath);
  }

  Future<void> _updateImageName(UpdateItemImageName event) async {
    return service.renameImage(itemId, event.newImageName);
  }

  Future<void> _deleteImage(DeleteItemImage event) async {
    return service.deleteImage(itemId);
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
    on<WarnItemDetailNotLoaded>(_mapWarnNotLoadedToState);
  }

  final int itemId;
  final S service;

  void _mapUpdateFieldToState(
    UpdateItemField<N> event,
    Emitter<ItemDetailManagerState> emit,
  ) async {
    try {
      await _update(event);
      emit(
        ItemFieldUpdated(),
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

  void _mapWarnNotLoadedToState(
    WarnItemDetailNotLoaded event,
    Emitter<ItemDetailManagerState> emit,
  ) {
    emit(ItemDetailNotLoaded(event.error));
  }

  Future<T> _update(UpdateItemField<N> event) {
    return service.update(itemId, event.item);
  }
}
