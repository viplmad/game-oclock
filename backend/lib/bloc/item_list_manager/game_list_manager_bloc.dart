import 'package:backend/model/model.dart' show Game;
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

class GameListManagerBloc extends ItemListManagerBloc<Game, GameRepository> {
  GameListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameRepository);
}