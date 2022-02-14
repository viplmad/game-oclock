import 'package:backend/entity/entity.dart' show GameEntity, GameID;
import 'package:backend/model/model.dart' show Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameRepository;

import 'item_detail_manager.dart';

class GameDetailManagerBloc
    extends ItemDetailManagerBloc<Game, GameEntity, GameID, GameRepository> {
  GameDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(
          id: GameID(itemId),
          repository: collectionRepository.gameRepository,
        );

  @override
  Future<Game> updateFuture(UpdateItemField<Game> event) {
    final GameEntity entity = GameMapper.modelToEntity(event.item);
    final GameEntity updatedEntity =
        GameMapper.modelToEntity(event.updatedItem);
    final Future<GameEntity> entityFuture =
        repository.update(entity, updatedEntity);
    return GameMapper.futureEntityToModel(entityFuture, repository.getImageURI);
  }

  @override
  Future<Game> addImage(AddItemImage<Game> event) {
    final Future<GameEntity> entityFuture =
        repository.uploadCover(id, event.imagePath, event.oldImageName);
    return GameMapper.futureEntityToModel(entityFuture, repository.getImageURI);
  }

  @override
  Future<Game> updateImageName(UpdateItemImageName<Game> event) {
    final Future<GameEntity> entityFuture =
        repository.renameCover(id, event.oldImageName, event.newImageName);
    return GameMapper.futureEntityToModel(entityFuture, repository.getImageURI);
  }

  @override
  Future<Game> deleteImage(DeleteItemImage<Game> event) {
    final Future<GameEntity> entityFuture =
        repository.deleteCover(id, event.imageName);
    return GameMapper.futureEntityToModel(entityFuture, repository.getImageURI);
  }
}
