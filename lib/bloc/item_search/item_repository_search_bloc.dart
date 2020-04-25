import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';


class ItemRepositorySearchBloc extends ItemSearchBloc {

  ItemRepositorySearchBloc({
    @required Type itemType,
    @required this.collectionRepository,
  }) : super(itemType: itemType);

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
  Future<List<CollectionItem>> getInitialItems() {

    return collectionRepository.getItemsWithView(itemType, 1, super.maxSuggestions).first;

  }

  @override
  Future<List<CollectionItem>> getSearchItems(String query) {

    return collectionRepository.getSearchItem(itemType, query, super.maxResults).first;

  }

}