import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class RomListBloc extends ItemListBloc<Game> {
  RomListBloc({
    required ICollectionRepository iCollectionRepository,
    required RomListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return iCollectionRepository.findAllRomGames();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.findAllRomGamesWithView(gameView);

  }

  @override
  Stream<List<Game>> getReadYearViewStream(UpdateYearView event) {

    final GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.findAllRomGamesWithYearView(gameView, event.year);

  }
}