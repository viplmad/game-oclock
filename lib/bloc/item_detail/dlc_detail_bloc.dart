import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_detail.dart';


class DLCDetailBloc extends ItemDetailBloc<DLC> {

  DLCDetailBloc({
    @required int dlcID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: dlcID, collectionRepository: collectionRepository);

  @override
  Stream<DLC> getReadStream() {

    return collectionRepository.getDLCWithID(itemID);

  }

  @override
  Future<DLC> updateFuture(UpdateItemField<DLC> event) {

    return collectionRepository.updateDLC(itemID, event.field, event.value);

  }

  @override
  Future<DLC> addImage(AddItemImage<DLC> event) {

    return collectionRepository.uploadDLCCover(itemID, event.imagePath, event.oldImageName);

  }

  @override
  Future<DLC> updateImageName(UpdateItemImageName<DLC> event) {

    return collectionRepository.renameDLCCover(itemID, event.oldImageName, event.newImageName);

  }

  @override
  Future<DLC> deleteImage(DeleteItemImage<DLC> event) {

    return collectionRepository.deleteDLCCover(itemID, event.imageName);

  }

}