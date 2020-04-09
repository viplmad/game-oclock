import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';


class ItemLocalSearchBloc extends ItemSearchBloc {

  ItemLocalSearchBloc({
    @required Type itemType,
    @required this.itemList,
  }) : super(itemType: itemType);

  final List<CollectionItem> itemList;

  @override
  Future<List<CollectionItem>> getInitialItems() {

    return Future<List<CollectionItem>>.value([]);

  }

  @override
  Future<List<CollectionItem>> getSearchItems(String query) {

    final List<CollectionItem> items = itemList.where( (CollectionItem item) {
      return item.getTitle().toLowerCase().contains(query.toLowerCase());
    }).take(super.maxResults).toList();
    return Future<List<CollectionItem>>.value(items);

  }

}