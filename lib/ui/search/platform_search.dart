import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import 'search.dart';


class PlatformSearch extends ItemSearch<Platform, PlatformSearchBloc, PlatformListManagerBloc> {

  @override
  PlatformSearchBloc searchBlocBuilder() {

    return PlatformSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  PlatformListManagerBloc managerBlocBuilder() {

    return PlatformListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

}

class PlatformLocalSearch extends ItemLocalSearch<Platform, PlatformListManagerBloc> {

  PlatformLocalSearch({
    Key key,
    @required List<Platform> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = platformDetailRoute;

  @override
  PlatformListManagerBloc managerBlocBuilder() {

    return PlatformListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }


}