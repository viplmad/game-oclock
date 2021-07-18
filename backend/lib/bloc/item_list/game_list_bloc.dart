import 'package:backend/model/model.dart' show Game, GameView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class AllListBloc extends GameListBloc {
  AllListBloc({
    required GameCollectionRepository collectionRepository,
    required AllListManagerBloc managerBloc,
  }) : super(collectionRepository: collectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return repository.findAllGamesWithView(gameView);

  }

  @override
  Stream<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return repository.findAllGamesWithYearView(gameView, event.year);

  }
}

class OwnedListBloc extends GameListBloc {
  OwnedListBloc({
    required GameCollectionRepository collectionRepository,
    required OwnedListManagerBloc managerBloc,
  }) : super(collectionRepository: collectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return repository.findAllOwnedGames();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return repository.findAllOwnedGamesWithView(gameView);

  }

  @override
  Stream<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return repository.findAllOwnedGamesWithYearView(gameView, event.year);

  }
}

class RomListBloc extends GameListBloc {
  RomListBloc({
    required GameCollectionRepository collectionRepository,
    required RomListManagerBloc managerBloc,
  }) : super(collectionRepository: collectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return repository.findAllRomGames();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return repository.findAllRomGamesWithView(gameView);

  }

  @override
  Stream<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return repository.findAllRomGamesWithYearView(gameView, event.year);

  }
}

abstract class GameListBloc extends ItemListBloc<Game, GameRepository> {
  GameListBloc({
    required GameCollectionRepository collectionRepository,
    required GameListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.gameRepository, managerBloc: managerBloc);
}