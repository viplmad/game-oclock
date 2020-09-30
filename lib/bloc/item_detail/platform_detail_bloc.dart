import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class PlatformDetailBloc extends ItemDetailBloc<Platform> {

  PlatformDetailBloc({
    @required PlatformBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<Platform> getReadIDStream(LoadItem event) {

    return collectionRepository.getPlatformWithID(event.ID);

  }

}