import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show FilterFormData, ListSearch;

import '../list.dart'
    show ListFinal, ListLoadBloc, ListLoadSuccess, ListReloaded;

class SearchListBloc extends ListLoadBloc<ListSearch> {
  SearchListBloc({required this.space});

  final String space;

  @override
  Future<ListFinal<ListSearch>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<ListSearch>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    // TODO fetch from local storage
    final data = List.generate(50, (final index) {
      final finalIndex = index;
      return mockSearch(name: 'search $finalIndex');
    });

    return ListLoadSuccess<ListSearch>(
      data: List.unmodifiable(data),
      quicksearch: quicksearch,
      search: search,
      total: data.length, // Everything has been "fetched"
    );
  }
}

class FilterFormDataListBloc extends LocalEditableListBloc<FilterFormData> {
  FilterFormDataListBloc({required super.data});
}

// TODO Move
abstract class LocalEditableListBloc<S> extends ListLoadBloc<S> {
  LocalEditableListBloc({required this.data});

  final List<S> data;

  @override
  Future<ListFinal<S>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<S>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    return ListLoadSuccess<S>(
      data: List.unmodifiable(data),
      quicksearch: quicksearch,
      search: search,
      total: data.length, // Everything has been "fetched"
    );
  }

  void addElement(final S newElement) {
    data.add(newElement);
    add(const ListReloaded());
  }

  void removeElement(final int index) {
    data.removeAt(index);
    add(const ListReloaded());
  }

  void replaceElement(final int oldIndex, final int newIndex) {
    final temp = data.elementAt(oldIndex);
    data[oldIndex] = data[newIndex];
    data[newIndex] = temp;
    add(const ListReloaded());
  }
}
