import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class PlatformDetailBloc extends ItemDetailBloc<Platform> {

  PlatformDetailBloc({
    @required int platformID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: platformID, collectionRepository: collectionRepository);

  @override
  Stream<Platform> getReadStream() {

    return collectionRepository.getPlatformWithID(itemID);

  }

  @override
  Future<Platform> updateFuture(UpdateItemField<Platform> event) {

    return collectionRepository.updatePlatform(itemID, event.field, event.value);

  }

  @override
  Future<Platform> addImage(AddItemImage<Platform> event) {

    return collectionRepository.uploadPlatformIcon(itemID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Platform> updateImageName(UpdateItemImageName<Platform> event) {

    return collectionRepository.renamePlatformIcon(itemID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Platform> deleteImage(DeleteItemImage<Platform> event) {

    return collectionRepository.deletePlatformIcon(itemID, event.imageName);

  }

}