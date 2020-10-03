import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_detail.dart';


class GameDetailBloc extends ItemDetailBloc<Game> {

  GameDetailBloc({
    @required int gameID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: gameID, collectionRepository: collectionRepository);

  @override
  Stream<Game> getReadStream() {

    return collectionRepository.getGameWithID(itemID);

  }

  @override
  Future<Game> updateFuture(UpdateItemField<Game> event) {

    return collectionRepository.updateGame(itemID, event.field, event.value);

  }

  @override
  Future<Game> addImage(AddItemImage<Game> event) {

    return collectionRepository.uploadGameCover(itemID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Game> updateImageName(UpdateItemImageName<Game> event) {

    return collectionRepository.renameGameCover(itemID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Game> deleteImage(DeleteItemImage<Game> event) {

    return collectionRepository.deleteGameCover(itemID, event.imageName);

  }

}