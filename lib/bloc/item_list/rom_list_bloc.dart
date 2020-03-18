import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class RomListBloc extends ItemListBloc {

  RomListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return collectionRepository.getAllRoms();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    int viewIndex = gameViews.indexOf(event.view);
    GameView gameView = GameView.values[viewIndex];

    return collectionRepository.getRomsWithView(gameView);

  }

}