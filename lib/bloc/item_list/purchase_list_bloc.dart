import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class PurchaseListBloc extends ItemListBloc {

  PurchaseListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Purchase>> getReadStream() {

    return collectionRepository.getAllPurchases();

  }

}