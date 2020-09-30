import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class DLCDetailBloc extends ItemDetailBloc<DLC> {

  DLCDetailBloc({
    @required DLCBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<DLC> getReadIDStream(LoadItem event) {

    return collectionRepository.getDLCWithID(event.ID);

  }

}