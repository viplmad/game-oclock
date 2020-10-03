import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class StoreDetailBloc extends ItemDetailBloc<Store> {

  StoreDetailBloc({
    @required int storeID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: storeID, collectionRepository: collectionRepository);

  @override
  Stream<Store> getReadStream() {

    return collectionRepository.getStoreWithID(itemID);

  }

  @override
  Future<Store> updateFuture(UpdateItemField<Store> event) {

    return collectionRepository.updateStore(itemID, event.field, event.value);

  }

  @override
  Future<Store> addImage(AddItemImage<Store> event) {

    return collectionRepository.uploadStoreIcon(itemID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Store> updateImageName(UpdateItemImageName<Store> event) {

    return collectionRepository.renameStoreIcon(itemID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Store> deleteImage(DeleteItemImage<Store> event) {

    return collectionRepository.deleteStoreIcon(itemID, event.imageName);

  }

}