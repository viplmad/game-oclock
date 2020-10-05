import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';

import '../route_constants.dart';
import 'search.dart';


class PlatformSearch extends ItemSearch<Platform, PlatformSearchBloc> {

  @override
  PlatformSearchBloc searchBlocBuilder() {

    return PlatformSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class PlatformLocalSearch extends ItemLocalSearch<Platform> {

  PlatformLocalSearch({
    Key key,
    @required List<Platform> items,
  }) : super(key: key, items: items);

  @override
  String detailRouteName = platformDetailRoute;


}