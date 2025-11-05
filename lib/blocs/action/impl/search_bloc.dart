import 'package:game_oclock/models/models.dart' show ListSearch;
import 'package:game_oclock/services/services.dart' show ListSearchService;

import '../action.dart'
    show
        ConsumerActionBloc,
        FunctionActionBloc,
        IdentityActionBloc,
        ProducerActionBloc;

class ListSearchGetBloc extends ProducerActionBloc<ListSearch> {
  ListSearchGetBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ListSearch> doAction(final void event, final ListSearch? lastData) =>
      service
          .getCurrent(space)
          .then((final value) => value ?? ListSearch.def());
}

class ListSearchSaveBloc extends ConsumerActionBloc<ListSearch> {
  ListSearchSaveBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<void> doAction(final ListSearch event, final void lastData) =>
      service.saveCurrent(space, event);
}

// TODO rename
class SearchGetBloc extends FunctionActionBloc<String, ListSearch> {
  SearchGetBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ListSearch> doAction(final String event, final ListSearch? lastData) =>
      service.get(space, event);
}

class SearchCreateBloc extends IdentityActionBloc<ListSearch> {
  SearchCreateBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ListSearch> doAction(
    final ListSearch event,
    final ListSearch? lastData,
  ) => service.create(space, event);
}

class SearchUpdateBloc extends ConsumerActionBloc<ListSearch> {
  SearchUpdateBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<void> doAction(final ListSearch event, final void lastData) =>
      service.update(space, event);
}
