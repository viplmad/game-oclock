import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';

import '../route_constants.dart';
import 'search.dart';


class SystemSearch extends ItemSearch<System, SystemSearchBloc> {

  @override
  SystemSearchBloc searchBlocBuilder() {

    return SystemSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class SystemLocalSearch extends ItemLocalSearch<System> {

  SystemLocalSearch({
    Key key,
    @required List<System> items,
  }) : super(key: key, items: items);

  @override
  void Function() onTap(BuildContext context, System item) {

    return null;

  }

}