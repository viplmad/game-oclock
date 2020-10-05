import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';

import '../route_constants.dart';
import 'search.dart';


class StoreSearch extends ItemSearch<Store, StoreSearchBloc> {

  @override
  StoreSearchBloc searchBlocBuilder() {

    return StoreSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class StoreLocalSearch extends ItemLocalSearch<Store> {

  StoreLocalSearch({
    Key key,
    @required List<Store> items,
  }) : super(key: key, items: items);

  @override
  String detailRouteName = storeDetailRoute;


}