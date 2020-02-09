import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class PlatformListBloc extends ItemListBloc {

  PlatformListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Platform>> getReadStream() {

    return collectionRepository.getAllPlatforms();

  }

}