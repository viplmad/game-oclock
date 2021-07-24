import 'package:backend/entity/entity.dart' show GameEntity, GameID, GameView;
import 'package:backend/model/model.dart' show Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class AllListBloc extends GameListBloc {
  AllListBloc({
    required GameCollectionRepository collectionRepository,
    required AllListManagerBloc managerBloc,
  }) : super(collectionRepository: collectionRepository, managerBloc: managerBloc);

  @override
  Future<List<Game>> getReadAllStream() {

    final Future<List<GameEntity>> entityListFuture = repository.findAllGamesWithView(GameView.Main);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadViewStream(UpdateView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllGamesWithView(view);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllGamesWithYearView(view, event.year);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}

class OwnedListBloc extends GameListBloc {
  OwnedListBloc({
    required GameCollectionRepository collectionRepository,
    required OwnedListManagerBloc managerBloc,
  }) : super(collectionRepository: collectionRepository, managerBloc: managerBloc);

  @override
  Future<List<Game>> getReadAllStream() {

    final Future<List<GameEntity>> entityListFuture = repository.findAllOwnedGamesWithView(GameView.Main);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadViewStream(UpdateView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllOwnedGamesWithView(view);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllOwnedGamesWithView(view, event.year);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}

class RomListBloc extends GameListBloc {
  RomListBloc({
    required GameCollectionRepository collectionRepository,
    required RomListManagerBloc managerBloc,
  }) : super(collectionRepository: collectionRepository, managerBloc: managerBloc);

  @override
  Future<List<Game>> getReadAllStream() {

    final Future<List<GameEntity>> entityListFuture = repository.findAllRomGamesWithView(GameView.Main);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadViewStream(UpdateView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllRomGamesWithView(view);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllRomGamesWithYearView(view, event.year);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}

abstract class GameListBloc extends ItemListBloc<Game, GameEntity, GameID, GameRepository> {
  GameListBloc({
    required GameCollectionRepository collectionRepository,
    required GameListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.gameRepository, managerBloc: managerBloc);
}