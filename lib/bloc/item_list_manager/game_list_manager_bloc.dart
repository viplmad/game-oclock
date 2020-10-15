import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list_manager.dart';


class AllListManagerBloc extends GameListManagerBloc {

  AllListManagerBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

}

class OwnedListManagerBloc extends GameListManagerBloc {

  OwnedListManagerBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

}

class RomListManagerBloc extends GameListManagerBloc {

  RomListManagerBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

}

class GameListManagerBloc extends ItemListManagerBloc<Game> {

  GameListManagerBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Game> createFuture(AddItem event) {

    return iCollectionRepository.createGame(event.title ?? '', '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Game> event) {

    return iCollectionRepository.deleteGame(event.item.id);

  }

}