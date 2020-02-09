import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class PurchaseDetailBloc extends ItemDetailBloc {

  PurchaseDetailBloc({
    @required ItemBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<Purchase> getReadIDStream(LoadItem event) {

    return collectionRepository.getPurchaseWithID(event.ID);

  }

}