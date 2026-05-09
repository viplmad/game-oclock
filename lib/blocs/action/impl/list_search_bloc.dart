import 'package:game_oclock/blocs/default_search.dart';
import 'package:game_oclock/models/models.dart'
    show GameOClockException, ListSearch, errorCodeNotFound;
import 'package:game_oclock/services/services.dart' show ListSearchService;

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, ProducerActionBloc;

class CurrentListSearchGetBloc extends ProducerActionBloc<ListSearch> {
  CurrentListSearchGetBloc({
    required this.service,
    required this.space,
    this.defaultId,
  });

  final ListSearchService service;
  final String space;
  final String? defaultId;

  @override
  Future<ListSearch> doAction(
    final void event,
    final ListSearch? lastData,
  ) async {
    final currentId = await getOrDefault();
    try {
      return defaultListSearch[space]!.firstWhere(
        (final element) => element.id == currentId,
      );
    } on StateError {
      return service.get(space, currentId);
    }
  }

  Future<String> getOrDefault() async {
    try {
      return await service.getCurrentKey(space);
    } on GameOClockException catch (e) {
      if (e.code == errorCodeNotFound && defaultId != null) {
        return defaultId!;
      }
      rethrow;
    }
  }
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

class ListSearchCreateBloc extends FunctionActionBloc<ListSearch, String> {
  ListSearchCreateBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<String> doAction(final ListSearch event, final String? lastData) =>
      service.create(space, event);
}

class ListSearchUpdateBloc extends ConsumerActionBloc<ListSearch> {
  ListSearchUpdateBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<void> doAction(final ListSearch event, final void lastData) =>
      service.update(space, event);
}
