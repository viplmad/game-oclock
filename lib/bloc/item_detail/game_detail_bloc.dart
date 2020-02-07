import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/game.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class GameDetailBloc extends ItemDetailBloc {

  GameDetailBloc({
    @required ItemBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<Game> getReadIDStream(int ID) {

    return collectionRepository.getGameWithID(ID);

  }

}