import 'package:game_oclock/models/models.dart'
    show ErrorDTO, ListSearch, errorCodeNotFound;
import 'package:game_oclock/services/services.dart' show ListSearchService;

import '../action.dart'
    show
        ActionFailure,
        ActionFinal,
        ActionSuccess,
        ConsumerActionBloc,
        FunctionActionBloc,
        IdentityActionBloc,
        ProducerActionBloc;

class ListSearchGetBloc extends ProducerActionBloc<ListSearch> {
  ListSearchGetBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ActionFinal<ListSearch, void>> doAction(
    final void event,
    final ListSearch? lastData,
  ) async {
    final data = await service.getCurrent(space);
    return data == null
        ? ActionFailure.producer(
            const ErrorDTO(
              code: errorCodeNotFound,
              message: 'No ListSearch saved',
            ),
            ListSearch.def(),
          )
        : ActionSuccess.producer(data);
  }
}

class ListSearchSaveBloc extends IdentityActionBloc<ListSearch> {
  ListSearchSaveBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ActionFinal<ListSearch, ListSearch>> doAction(
    final ListSearch event,
    final ListSearch? lastData,
  ) async {
    await service.saveCurrent(space, event);
    return ActionSuccess(data: event, event: event);
  }
}

// TODO rename
class SearchGetBloc extends FunctionActionBloc<String, ListSearch> {
  SearchGetBloc({required this.service, required this.space});

  final ListSearchService service;
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

class SearchCreateBloc extends IdentityActionBloc<ListSearch> {
  SearchCreateBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ActionFinal<ListSearch, ListSearch>> doAction(
    final ListSearch event,
    final ListSearch? lastData,
  ) async {
    final data = await service.create(space, event);
    return ActionSuccess(data: data, event: event);
  }
}

class SearchUpdateBloc extends ConsumerActionBloc<ListSearch> {
  SearchUpdateBloc({required this.service, required this.space});

  final ListSearchService service;
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
