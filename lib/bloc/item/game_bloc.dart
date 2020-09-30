import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class GameBloc extends ItemBloc<Game> {

  GameBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Game> createFuture(AddItem event) {

    return collectionRepository.insertGame(event.title ?? '', '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Game> event) {

    return collectionRepository.deleteGame(event.item.ID);

  }

  @override
  Future<Game> updateFuture(UpdateItemField<Game> event) {

    return collectionRepository.updateGame(event.item.ID, event.field, event.value);

  }

  @override
  Future<Game> addImage(AddItemImage<Game> event) {

    return collectionRepository.uploadGameCover(event.item.ID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Game> updateImageName(UpdateItemImageName<Game> event) {

    return collectionRepository.renameGameCover(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Game> deleteImage(DeleteItemImage<Game> event) {

    return collectionRepository.deleteGameCover(event.item.ID, event.imageName);

  }

}