import 'dart:async';

import 'package:game_collection/entity/entity.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class GameListBloc extends ItemListBloc {

  GameListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Game>> getReadAllStream() {

    return collectionRepository.getAllGames();

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    if(event.view == GameViews[0]) {

      return getReadAllStream();

    } else if(event.view == GameViews[1]) {

      return collectionRepository.getGames(
        <String, dynamic>{
          game_statusField: statuses[2],
        },
      );

    } else if(event.view == GameViews[2]) {

      return collectionRepository.getGames(
        <String, dynamic>{
          game_statusField: statuses[3],
        },
        [
          game_finishDateField,
        ],
      );

    } else if(event.view == GameViews[3]) {

      // TODO: Handle this case.
      return getReadAllStream();

    }

  }

}