import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';


class ItemLocalSearchBloc<T extends CollectionItem> extends ItemSearchBloc<T> {

  ItemLocalSearchBloc({
    @required this.itemList,
  }) : super();

  final List<T> itemList;

  @override
  Stream<ItemSearchState> checkConnection() async* {

  }

  @override
  Future<List<T>> getInitialItems() {

    return Future<List<T>>.value([]);

  }

  @override
  Future<List<T>> getSearchItems(String query) {

    final List<T> items = itemList.where( (T item) {
      return item.getTitle().toLowerCase().contains(query.toLowerCase());
    }).take(super.maxResults).toList();
    return Future<List<T>>.value(items);

  }

}