import 'package:backend/entity/entity.dart' show GameEntity, GameID, GameView;
import 'package:backend/model/model.dart' show Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import 'item_search.dart';


class GameSearchBloc extends ItemRemoteSearchBloc<Game, GameEntity, GameID, GameRepository> {
  GameSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameRepository);

  @override
  Future<List<Game>> getInitialItems() {

    final Future<List<GameEntity>> entityListFuture = repository.findAllOwnedWithView(GameView.LastCreated, super.maxSuggestions);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getSearchItems(String query) {

    final Future<List<GameEntity>> entityListFuture = repository.findAllByName(query, super.maxResults);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}