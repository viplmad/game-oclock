import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/game.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class GameListBloc extends ItemListBloc {

  GameListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Game>> getReadStream() {

    return collectionRepository.getAllGames();

  }

}