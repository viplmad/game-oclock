import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class OwnedListBloc extends ItemListBloc<Game> {
  OwnedListBloc({
    required CollectionRepository iCollectionRepository,
    required OwnedListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return iCollectionRepository.findAllOwnedGames();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.findAllOwnedGamesWithView(gameView);

  }

  @override
  Stream<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.findAllOwnedGamesWithYearView(gameView, event.year);

  }
}