import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class OwnedListBloc extends ItemListBloc<Game> {
  OwnedListBloc({
    required ICollectionRepository iCollectionRepository,
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