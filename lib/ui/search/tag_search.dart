import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';

import 'search.dart';

class TagSearch extends ItemSearch<Tag, TagSearchBloc> {

  @override
  TagSearchBloc searchBlocBuilder() {

    return TagSearchBloc(
      collectionRepository: CollectionRepository(),
    );

  }

}