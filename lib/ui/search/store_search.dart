import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import 'search.dart';


class StoreSearch extends ItemSearch<Store, StoreSearchBloc, StoreListManagerBloc> {

  @override
  StoreSearchBloc searchBlocBuilder() {

    return StoreSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

  @override
  StoreListManagerBloc managerBlocBuilder() {

    return StoreListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class StoreLocalSearch extends ItemLocalSearch<Store, StoreListManagerBloc> {

  StoreLocalSearch({
    Key key,
    @required List<Store> items,
  }) : super(key: key, items: items);

  @override
  String detailRouteName = storeDetailRoute;

  @override
  StoreListManagerBloc managerBlocBuilder() {

    return StoreListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }


}