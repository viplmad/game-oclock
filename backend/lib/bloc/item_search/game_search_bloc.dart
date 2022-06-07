import 'package:backend/entity/entity.dart' show GameEntity, GameID, GameView;
import 'package:backend/model/model.dart' show Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameRepository;

import 'item_search.dart';

class GameSearchBloc
    extends ItemRemoteSearchBloc<Game, GameEntity, GameID, GameRepository> {
  GameSearchBloc({
    required GameCollectionRepository collectionRepository,
    required super.viewIndex,
    this.viewYear,
  }) : super(repository: collectionRepository.gameRepository);

  final int? viewYear;

  @override
  Future<List<Game>> getInitialItems() {
    final GameView view =
        viewIndex != null ? GameView.values[viewIndex!] : GameView.lastCreated;
    final Future<List<GameEntity>> entityListFuture =
        repository.findFirstWithView(view, super.maxSuggestions, viewYear);
    return GameMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }

  @override
  Future<List<Game>> getSearchItems(String query) {
    if (viewIndex != null) {
      final GameView view = GameView.values[viewIndex!];
      final Future<List<GameEntity>> entityListFuture = repository
          .findFirstWithViewByName(view, query, super.maxResults, viewYear);
      return GameMapper.futureEntityListToModelList(
        entityListFuture,
        repository.getImageURI,
      );
    } else {
      final Future<List<GameEntity>> entityListFuture =
          repository.findFirstByName(query, super.maxResults);
      return GameMapper.futureEntityListToModelList(
        entityListFuture,
        repository.getImageURI,
      );
    }
  }
}
