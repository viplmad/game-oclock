import 'package:game_oclock/blocs/form/search_form_bloc.dart';
import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, PageResultDTO;

import 'list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess, ListReloaded;

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

    final page = search.search.page ?? 0;
    final size = search.search.size ?? 50; // TODO Set in bloc?
    final data = PageResultDTO(
      data: List.generate(size, (final index) {
        final finalIndex = (page * size) + index;
        return mockSearch(name: 'search $finalIndex');
      }),
      page: page,
      size: size,
    );

    return ListLoadSuccess<ListSearch>(
      data: List.of(
        lastData == null ? data.data : [...lastData, ...data.data],
        growable: false,
      ),
      quicksearch: quicksearch,
      search: search,
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
