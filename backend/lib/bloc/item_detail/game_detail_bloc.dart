import 'package:backend/entity/entity.dart' show GameEntity, GameID;
import 'package:backend/model/model.dart' show Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class GameDetailBloc extends ItemDetailBloc<Game, GameEntity, GameID, GameRepository> {
  GameDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required GameDetailManagerBloc managerBloc,
  }) : super(id: GameID(itemId), repository: collectionRepository.gameRepository, managerBloc: managerBloc);

  @override
  Future<Game> getReadFuture() {

    final Future<GameEntity> entityFuture = repository.findById(id);
    return GameMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }
}