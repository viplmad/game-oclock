import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import 'search.dart';


class TypeSearch extends ItemSearch<PurchaseType, TypeSearchBloc, TypeListManagerBloc> {

  @override
  TypeSearchBloc searchBlocBuilder() {

    return TypeSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  TypeListManagerBloc managerBlocBuilder() {

    return TypeListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

}

class TypeLocalSearch extends ItemLocalSearch<PurchaseType, TypeListManagerBloc> {

  TypeLocalSearch({
    Key key,
    @required List<PurchaseType> items,
  }) : super(key: key, items: items);

  @override
  void Function() onTap(BuildContext context, PurchaseType item) {

    return null;

  }

  @override
  TypeListManagerBloc managerBlocBuilder() {

    return TypeListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

}