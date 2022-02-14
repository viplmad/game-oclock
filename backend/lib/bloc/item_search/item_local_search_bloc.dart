import 'package:backend/model/model.dart' show Item;

import 'item_search.dart' show ItemSearchBloc;

class ItemLocalSearchBloc<T extends Item> extends ItemSearchBloc<T> {
  ItemLocalSearchBloc({
    required this.items,
  });

  final List<T> items;

  @override
  Future<List<T>> getInitialItems() {
    return Future<List<T>>.value(<T>[]);
  }

  @override
  Future<List<T>> getSearchItems(String query) {
    final List<T> searchItems = items
        .where((T item) {
          return item.queryableTerms
              .toLowerCase()
              .contains(query.toLowerCase());
        })
        .take(super.maxResults)
        .toList(growable: false);

    return Future<List<T>>.value(searchItems);
  }
}
