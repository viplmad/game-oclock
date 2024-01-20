import 'package:game_oclock_client/api.dart'
    show GameDTO, GamePageResult, GameStatus, NewGameDTO;

import 'package:logic/service/service.dart' show GameOClockService, GameService;

import 'item_list.dart';

class GameWishlistedListBloc
    extends ItemListBloc<GameDTO, NewGameDTO, GameService> {
  GameWishlistedListBloc({
    required GameOClockService collectionService,
    required super.managerBloc,
  }) : super(service: collectionService.gameService);

  @override
  Future<List<GameDTO>> getAllWithView(
    int viewIndex, [
    int? page,
  ]) async {
    final GamePageResult result =
        await service.getAllWithStatus(GameStatus.wishlist, page: page);
    return result.data;
  }
}
