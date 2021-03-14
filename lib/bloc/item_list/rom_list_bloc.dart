import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class RomListBloc extends ItemListBloc<Game> {
  RomListBloc({
    required ICollectionRepository iCollectionRepository,
    required RomListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return iCollectionRepository.getAllRoms();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.getRomsWithView(gameView);

  }

  @override
  Stream<List<Game>> getReadYearViewStream(UpdateYearView event) {

    GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.getRomsWithYearView(gameView, event.year);

  }
}