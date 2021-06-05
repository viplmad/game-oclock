import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class AllListBloc extends ItemListBloc<Game> {
  AllListBloc({
    required CollectionRepository iCollectionRepository,
    required AllListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return iCollectionRepository.findAllGames();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.findAllGamesWithView(gameView);

  }

  @override
  Stream<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.findAllGamesWithYearView(gameView, event.year);

  }
}