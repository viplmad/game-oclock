import 'package:game_collection_client/api.dart' show GameDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, GameService;
import 'package:backend/model/model.dart' show GameView;

import 'item_search.dart';

class GameSearchBloc extends ItemSearchBloc<GameDTO, GameService> {
  GameSearchBloc({
    required GameCollectionService collectionService,
  }) : super(
          service: collectionService.gameService,
          initialViewIndex: GameView.lastUpdated.index,
        );
}
