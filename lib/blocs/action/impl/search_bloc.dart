import 'package:game_oclock/models/models.dart' show ListSearch;
import 'package:game_oclock/services/services.dart' show SearchService;

import '../action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

class SearchGetBloc extends FunctionActionBloc<String, ListSearch> {
  SearchGetBloc({required this.service, required this.space});

  final SearchService service;
  final String space;

  @override
  Future<ActionFinal<ListSearch, String>> doAction(
    final String event,
    final ListSearch? lastData,
  ) async {
    final data = await service.get(space, event);
    return ActionSuccess(data: data, event: event);
  }
}

class SearchCreateBloc extends ConsumerActionBloc<ListSearch> {
  SearchCreateBloc({required this.service, required this.space});

  final SearchService service;
  final String space;

  @override
  Future<ActionFinal<void, ListSearch>> doAction(
    final ListSearch event,
    final void lastData,
  ) async {
    await service.create(space, event);
    return ActionSuccess.consumer(event);
  }
}

class SearchUpdateBloc extends ConsumerActionBloc<ListSearch> {
  SearchUpdateBloc({required this.service, required this.space});

  final SearchService service;
  final String space;

  @override
  Future<ActionFinal<void, ListSearch>> doAction(
    final ListSearch event,
    final void lastData,
  ) async {
    await service.update(space, event);
    return ActionSuccess.consumer(event);
  }
}
