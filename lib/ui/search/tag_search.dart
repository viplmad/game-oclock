import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import 'search.dart';


class TagSearch extends ItemSearch<Tag, TagSearchBloc, TagListManagerBloc> {

  @override
  TagSearchBloc searchBlocBuilder() {

    return TagSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  TagListManagerBloc managerBlocBuilder() {

    return TagListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

}

class TagLocalSearch extends ItemLocalSearch<Tag, TagListManagerBloc> {

  TagLocalSearch({
    Key key,
    @required List<Tag> items,
  }) : super(key: key, items: items);

  @override
  void Function() onTap(BuildContext context, Tag item) {

    return null;

  }

  @override
  TagListManagerBloc managerBlocBuilder() {

    return TagListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

}