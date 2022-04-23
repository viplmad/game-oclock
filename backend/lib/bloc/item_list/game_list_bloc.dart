import 'package:backend/entity/entity.dart' show GameEntity, GameID, GameView;
import 'package:backend/model/model.dart' show Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameRepository;
import 'package:backend/preferences/repository_preferences.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';

class AllListBloc extends GameListBloc {
  AllListBloc({
    required GameCollectionRepository collectionRepository,
    required AllListManagerBloc managerBloc,
  }) : super(
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        );

  @override
  Future<ViewParameters> getStartViewIndex() async {
    final int startViewIndex =
        await RepositoryPreferences.retrieveInitialGameViewIndex() ??
            GameView.main.index;

    return Future<ViewParameters>.value(
      ViewParameters(
        startViewIndex,
        startViewIndex == GameView.review.index ? DateTime.now().year : null,
      ),
    );
  }

  @override
  Future<List<Game>> getAllWithView(int viewIndex, [int? page]) {
    final GameView view = GameView.values[viewIndex];
    final Future<List<GameEntity>> entityListFuture =
        repository.findAllWithView(view, page);
    return GameMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }

  @override
  Future<List<Game>> getAllWithYearView(
    int viewIndex,
    int year, [
    int? page,
  ]) {
    final GameView view = GameView.values[viewIndex];
    final Future<List<GameEntity>> entityListFuture =
        repository.findAllWithYearView(view, year, page);
    return GameMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }
}

class OwnedListBloc extends GameListBloc {
  OwnedListBloc({
    required GameCollectionRepository collectionRepository,
    required OwnedListManagerBloc managerBloc,
  }) : super(
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        );

  @override
  Future<ViewParameters> getStartViewIndex() async {
    final int startViewIndex =
        await RepositoryPreferences.retrieveInitialGameViewIndex() ??
            GameView.main.index;

    return Future<ViewParameters>.value(
      ViewParameters(
        startViewIndex,
        startViewIndex == GameView.review.index ? DateTime.now().year : null,
      ),
    );
  }

  @override
  Future<List<Game>> getAllWithView(int viewIndex, [int? page]) {
    final GameView view = GameView.values[viewIndex];
    final Future<List<GameEntity>> entityListFuture =
        repository.findAllOwnedWithView(view, page);
    return GameMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }

  @override
  Future<List<Game>> getAllWithYearView(
    int viewIndex,
    int year, [
    int? page,
  ]) {
    final GameView view = GameView.values[viewIndex];
    final Future<List<GameEntity>> entityListFuture =
        repository.findAllOwnedWithYearView(view, year, page);
    return GameMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }
}

class RomListBloc extends GameListBloc {
  RomListBloc({
    required GameCollectionRepository collectionRepository,
    required RomListManagerBloc managerBloc,
  }) : super(
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        );

  @override
  Future<ViewParameters> getStartViewIndex() async {
    final int startViewIndex =
        await RepositoryPreferences.retrieveInitialGameViewIndex() ??
            GameView.main.index;

    return Future<ViewParameters>.value(
      ViewParameters(
        startViewIndex,
        startViewIndex == GameView.review.index ? DateTime.now().year : null,
      ),
    );
  }

  @override
  Future<List<Game>> getAllWithView(int viewIndex, [int? page]) {
    final GameView view = GameView.values[viewIndex];
    final Future<List<GameEntity>> entityListFuture =
        repository.findAllRomWithView(view, page);
    return GameMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }

  @override
  Future<List<Game>> getAllWithYearView(
    int viewIndex,
    int year, [
    int? page,
  ]) {
    final GameView view = GameView.values[viewIndex];
    final Future<List<GameEntity>> entityListFuture =
        repository.findAllRomWithYearView(view, year, page);
    return GameMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }
}

abstract class GameListBloc
    extends ItemListBloc<Game, GameEntity, GameID, GameRepository> {
  GameListBloc({
    required GameCollectionRepository collectionRepository,
    required GameListManagerBloc managerBloc,
  }) : super(
          repository: collectionRepository.gameRepository,
          managerBloc: managerBloc,
        );
}
