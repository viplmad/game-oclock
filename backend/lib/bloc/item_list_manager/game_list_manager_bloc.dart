import 'package:backend/entity/entity.dart' show GameEntity, GameID;
import 'package:backend/model/model.dart' show Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import 'item_list_manager.dart';


class AllListManagerBloc extends GameListManagerBloc {
  AllListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);
}

class OwnedListManagerBloc extends GameListManagerBloc {
  OwnedListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);
}

class RomListManagerBloc extends GameListManagerBloc {
  RomListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);
}

class GameListManagerBloc extends ItemListManagerBloc<Game, GameEntity, GameID, GameRepository> {
  GameListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameRepository);

  @override
  Future<Game> createFuture(AddItem<Game> event) {

    final GameEntity entity = GameMapper.modelToEntity(event.item);
    final Future<GameEntity> entityFuture = repository.create(entity);
    return GameMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Game> event) {

    final GameEntity entity = GameMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());

  }
}