import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';

import '../route_constants.dart';
import 'search.dart';


class TypeSearch extends ItemSearch<PurchaseType, TypeSearchBloc> {

  @override
  TypeSearchBloc searchBlocBuilder() {

    return TypeSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class TypeLocalSearch extends ItemLocalSearch<PurchaseType> {

  TypeLocalSearch({
    Key key,
    @required List<PurchaseType> items,
  }) : super(key: key, items: items);

  @override
  void Function() onTap(BuildContext context, PurchaseType item) {

    return null;

  }

}