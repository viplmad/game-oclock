import 'package:game_oclock/models/models.dart' show ListSearch;
import 'package:game_oclock/services/services.dart' show ListSearchService;

import '../action.dart'
    show
        ConsumerActionBloc,
        FunctionActionBloc,
        IdentityActionBloc,
        ProducerActionBloc;

class CurrentListSearchGetBloc extends ProducerActionBloc<ListSearch> {
  CurrentListSearchGetBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ListSearch> doAction(final void event, final ListSearch? lastData) =>
      service.getCurrent(space);
}

class CurrentListSearchSaveBloc extends ConsumerActionBloc<ListSearch?> {
  CurrentListSearchSaveBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<void> doAction(final ListSearch? event, final void lastData) =>
      event == null
      ? service.removeCurrent(space)
      : service.saveCurrent(space, event);
}

class ListSearchGetBloc extends FunctionActionBloc<String, ListSearch> {
  ListSearchGetBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ListSearch> doAction(final String event, final ListSearch? lastData) =>
      service.get(space, event);
}

class ListSearchCreateBloc extends IdentityActionBloc<ListSearch> {
  ListSearchCreateBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ListSearch> doAction(
    final ListSearch event,
    final ListSearch? lastData,
  ) => service.create(space, event);
}

class ListSearchUpdateBloc extends ConsumerActionBloc<ListSearch> {
  ListSearchUpdateBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<void> doAction(final ListSearch event, final void lastData) =>
      service.update(space, event);
}
