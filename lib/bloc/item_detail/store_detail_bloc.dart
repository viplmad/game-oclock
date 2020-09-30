import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class StoreDetailBloc extends ItemDetailBloc<Store> {

  StoreDetailBloc({
    @required StoreBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<Store> getReadIDStream(LoadItem event) {

    return collectionRepository.getStoreWithID(event.ID);

  }

}