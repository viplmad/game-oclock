import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class GameDetailManagerBloc extends ItemDetailManagerBloc<Game, GameUpdateProperties> {
  GameDetailManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<Game?> updateFuture(UpdateItemField<Game, GameUpdateProperties> event) {

    return iCollectionRepository.updateGame(event.item, event.updatedItem, event.updateProperties);

  }

  @override
  Future<Game?> addImage(AddItemImage<Game> event) {

    return iCollectionRepository.uploadGameCover(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<Game?> updateImageName(UpdateItemImageName<Game> event) {

    return iCollectionRepository.renameGameCover(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<Game?> deleteImage(DeleteItemImage<Game> event) {

    return iCollectionRepository.deleteGameCover(itemId, event.imageName);

  }
}