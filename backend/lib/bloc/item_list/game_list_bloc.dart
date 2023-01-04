import 'package:game_collection_client/api.dart' show GameDTO, NewGameDTO;

import 'package:backend/service/service.dart'
    show GameService, GameCollectionService;
import 'package:backend/model/model.dart' show GameView;
import 'package:backend/preferences/shared_preferences_state.dart';

import 'item_list.dart';

class GameListBloc extends ItemListBloc<GameDTO, NewGameDTO, GameService> {
  GameListBloc({
    required GameCollectionService collectionService,
    required super.managerBloc,
  }) : super(service: collectionService.gameService);

  @override
  Future<ViewParameters> getStartViewIndex() async {
    final int startViewIndex =
        await SharedPreferencesState.retrieveInitialGameViewIndex() ??
            GameView.main.index;

    return Future<ViewParameters>.value(
      ViewParameters(
        startViewIndex,
        startViewIndex == GameView.review.index ? DateTime.now().year : null,
      ),
    );
  }
}
