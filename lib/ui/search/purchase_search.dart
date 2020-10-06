import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import 'search.dart';


class PurchaseSearch extends ItemSearch<Purchase, PurchaseSearchBloc, PurchaseListManagerBloc> {

  @override
  PurchaseSearchBloc searchBlocBuilder() {

    return PurchaseSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

  @override
  PurchaseListManagerBloc managerBlocBuilder() {

    return PurchaseListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class PurchaseLocalSearch extends ItemLocalSearch<Purchase, PurchaseListManagerBloc> {

  PurchaseLocalSearch({
    Key key,
    @required List<Purchase> items,
  }) : super(key: key, items: items);

  @override
  String detailRouteName = purchaseDetailRoute;

  @override
  PurchaseListManagerBloc managerBlocBuilder() {

    return PurchaseListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }


}