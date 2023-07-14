import 'package:game_collection_client/api.dart'
    show GameDTO, GamePageResult, GameStatus, NewGameDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameService;

import 'item_list.dart';

class GameWishlistedListBloc
    extends ItemListBloc<GameDTO, NewGameDTO, GameService> {
  GameWishlistedListBloc({
    required GameCollectionService collectionService,
    required super.managerBloc,
  }) : super(service: collectionService.gameService);

  @override
  Future<List<GameDTO>> getAllWithView(
    int viewIndex,
    Object? viewArgs, [
    int? page,
  ]) async {
    final GamePageResult result =
        await service.getAllWithStatus(GameStatus.wishlist, page: page);
    return result.data;
  }
}
