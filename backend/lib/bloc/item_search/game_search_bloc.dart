import 'package:backend/model/model.dart' show Game, GameView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import 'item_search.dart';


class GameSearchBloc extends ItemRemoteSearchBloc<Game, GameRepository> {
  GameSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameRepository);

  @override
  Future<List<Game>> getInitialItems() {

    return repository.findAllOwnedGamesWithView(GameView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Game>> getSearchItems(String query) {

    return repository.findAllGamesByName(query, super.maxResults).first;

  }
}