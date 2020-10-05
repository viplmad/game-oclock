import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';

import '../route_constants.dart';
import 'search.dart';


class TagSearch extends ItemSearch<Tag, TagSearchBloc> {

  @override
  TagSearchBloc searchBlocBuilder() {

    return TagSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class TagLocalSearch extends ItemLocalSearch<Tag> {

  TagLocalSearch({
    Key key,
    @required List<Tag> items,
  }) : super(key: key, items: items);

  @override
  void Function() onTap(BuildContext context, Tag item) {

    return null;

  }

}