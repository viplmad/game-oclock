import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class GameDetailBloc extends ItemDetailBloc<Game> {

  GameDetailBloc({
    @required GameBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<Game> getReadIDStream(LoadItem event) {

    return collectionRepository.getGameWithID(event.ID);

  }

}