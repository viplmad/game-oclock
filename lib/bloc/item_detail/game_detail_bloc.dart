import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class GameDetailBloc extends ItemDetailBloc<Game> {

  GameDetailBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<Game> getReadStream() {

    return iCollectionRepository.getGameWithID(itemID);

  }

  @override
  Future<Game> updateFuture(UpdateItemField<Game> event) {

    return iCollectionRepository.updateGame(itemID, event.field, event.value);

  }

  @override
  Future<Game> addImage(AddItemImage<Game> event) {

    return iCollectionRepository.uploadGameCover(itemID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Game> updateImageName(UpdateItemImageName<Game> event) {

    return iCollectionRepository.renameGameCover(itemID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Game> deleteImage(DeleteItemImage<Game> event) {

    return iCollectionRepository.deleteGameCover(itemID, event.imageName);

  }

}