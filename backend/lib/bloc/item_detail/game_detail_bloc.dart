import 'package:backend/model/model.dart' show Game;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class GameDetailBloc extends ItemDetailBloc<Game, GameRepository> {
  GameDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required GameDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, repository: collectionRepository.gameRepository, managerBloc: managerBloc);
}