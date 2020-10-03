import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class SystemDetailBloc extends ItemDetailBloc<System> {

  SystemDetailBloc({
    @required int systemID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: systemID, collectionRepository: collectionRepository);

  @override
  Stream<System> getReadStream() {

    return collectionRepository.getSystemWithID(itemID);

  }

  @override
  Future<System> updateFuture(UpdateItemField<System> event) {

    return collectionRepository.updateSystem(itemID, event.field, event.value);

  }

  @override
  Future<System> addImage(AddItemImage<System> event) {

    return collectionRepository.uploadSystemIcon(itemID, event.imagePath, event.oldImageName);

  }

  @override
  Future<System> updateImageName(UpdateItemImageName<System> event) {

    return collectionRepository.renameSystemIcon(itemID, event.oldImageName, event.newImageName);

  }

  @override
  Future<System> deleteImage(DeleteItemImage<System> event) {

    return collectionRepository.deleteSystemIcon(itemID, event.imageName);

  }

}