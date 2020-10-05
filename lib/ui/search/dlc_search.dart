import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';

import '../route_constants.dart';
import 'search.dart';


class DLCSearch extends ItemSearch<DLC, DLCSearchBloc> {

  @override
  DLCSearchBloc searchBlocBuilder() {

    return DLCSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class DLCLocalSearch extends ItemLocalSearch<DLC> {

  DLCLocalSearch({
    Key key,
    @required List<DLC> items,
  }) : super(key: key, items: items);

  @override
  String detailRouteName = dlcDetailRoute;


}