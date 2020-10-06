import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import 'search.dart';


class SystemSearch extends ItemSearch<System, SystemSearchBloc, SystemListManagerBloc> {

  @override
  SystemSearchBloc searchBlocBuilder() {

    return SystemSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

  @override
  SystemListManagerBloc managerBlocBuilder() {

    return SystemListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class SystemLocalSearch extends ItemLocalSearch<System, SystemListManagerBloc> {

  SystemLocalSearch({
    Key key,
    @required List<System> items,
  }) : super(key: key, items: items);

  @override
  void Function() onTap(BuildContext context, System item) {

    return null;

  }

  @override
  SystemListManagerBloc managerBlocBuilder() {

    return SystemListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}