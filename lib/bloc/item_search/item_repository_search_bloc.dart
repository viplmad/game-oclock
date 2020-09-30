import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';


class ItemRepositorySearchBloc<T extends CollectionItem> extends ItemSearchBloc<T> {

  ItemRepositorySearchBloc({
    @required this.collectionRepository,
  }) : super();

  final ICollectionRepository collectionRepository;

  @override
  Stream<ItemSearchState> checkConnection() async* {

    if(collectionRepository.isClosed()) {
      yield ItemSearchError("Connection lost. Trying to reconnect");

      try {

        collectionRepository.reconnect();
        await collectionRepository.open();

      } catch(e) {
      }
    }

  }

  @override
  Future<List<T>> getInitialItems() {

    return collectionRepository.getItemsWithView<T>(1, super.maxSuggestions).first;

  }

  @override
  Future<List<T>> getSearchItems(String query) {

    return collectionRepository.getSearchItem<T>(query, super.maxResults).first;

  }

}