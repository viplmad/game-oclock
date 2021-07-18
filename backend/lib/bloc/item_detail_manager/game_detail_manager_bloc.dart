import 'package:backend/model/model.dart' show Game;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import 'item_detail_manager.dart';


class GameDetailManagerBloc extends ItemDetailManagerBloc<Game, GameRepository> {
  GameDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(itemId: itemId, repository: collectionRepository.gameRepository);

  @override
  Future<Game?> addImage(AddItemImage<Game> event) {

    return repository.uploadGameCover(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<Game?> updateImageName(UpdateItemImageName<Game> event) {

    return repository.renameGameCover(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<Game?> deleteImage(DeleteItemImage<Game> event) {

    return repository.deleteGameCover(itemId, event.imageName);

  }
}