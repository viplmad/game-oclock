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

    final Future<List<GameEntity>> entityListFuture = repository.findAllWithView(GameView.main);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadViewStream(UpdateView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllWithView(view);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllWithYearView(view, event.year);
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

    final Future<List<GameEntity>> entityListFuture = repository.findAllOwnedWithView(GameView.main);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadViewStream(UpdateView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllOwnedWithView(view);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllOwnedWithYearView(view, event.year);
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

    final Future<List<GameEntity>> entityListFuture = repository.findAllRomWithView(GameView.main);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadViewStream(UpdateView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllRomWithView(view);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView view = GameView.values[event.viewIndex];
    final Future<List<GameEntity>> entityListFuture = repository.findAllRomWithYearView(view, event.year);
    return GameMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}

abstract class GameListBloc extends ItemListBloc<Game, GameEntity, GameID, GameRepository> {
  GameListBloc({
    required GameCollectionRepository collectionRepository,
    required GameListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.gameRepository, managerBloc: managerBloc);
}