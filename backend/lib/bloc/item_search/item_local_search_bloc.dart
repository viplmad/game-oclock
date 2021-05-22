import 'package:backend/model/model.dart';

import 'item_search.dart';


class ItemLocalSearchBloc<T extends CollectionItem> extends ItemSearchBloc<T> {
  ItemLocalSearchBloc({
    required this.items,
  }) : super(iCollectionRepository: null);

  final List<T> items;

  @override
  Stream<ItemSearchState> checkConnection() async* {}

  @override
  Future<List<T>> getInitialItems() {

    return Future<List<T>>.value(<T>[]);

  }

  @override
  Future<List<T>> getSearchItems(String query) {

    final List<T> searchItems = items.where( (T item) {
      return item.queryableTerms.toLowerCase().contains(query.toLowerCase());
    }).take(super.maxResults).toList(growable: false);

    return Future<List<T>>.value(searchItems);

  }
}