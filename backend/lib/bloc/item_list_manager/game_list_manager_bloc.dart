import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_list_manager.dart';


class AllListManagerBloc extends GameListManagerBloc {
  AllListManagerBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);
}

class OwnedListManagerBloc extends GameListManagerBloc {
  OwnedListManagerBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);
}

class RomListManagerBloc extends GameListManagerBloc {
  RomListManagerBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);
}

class GameListManagerBloc extends ItemListManagerBloc<Game> {
  GameListManagerBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Game?> createFuture(AddItem<Game> event) {

    return iCollectionRepository.createGame(event.item);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Game> event) {

    return iCollectionRepository.deleteGameById(event.item.id);

  }
}