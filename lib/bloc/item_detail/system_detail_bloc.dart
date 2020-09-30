import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class SystemDetailBloc extends ItemDetailBloc<System> {

  SystemDetailBloc({
    @required SystemBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<System> getReadIDStream(LoadItem event) {

    return collectionRepository.getSystemWithID(event.ID);

  }

}