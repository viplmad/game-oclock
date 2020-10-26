import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class OwnedListBloc extends ItemListBloc<Game> {
  OwnedListBloc({
    @required ICollectionRepository iCollectionRepository,
    @required OwnedListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return iCollectionRepository.getAllOwned();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.getOwnedWithView(gameView);

  }

  @override
  Stream<List<Game>> getReadYearViewStream(UpdateYearView event) {

    GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.getOwnedWithYearView(gameView, event.year);

  }
}