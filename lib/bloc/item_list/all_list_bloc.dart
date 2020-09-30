import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class AllListBloc extends ItemListBloc<Game> {

  AllListBloc({
    @required GameBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return collectionRepository.getAll();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    int viewIndex = gameViews.indexOf(event.view);
    GameView gameView = GameView.values[viewIndex];

    return collectionRepository.getAllWithView(gameView);

  }

}