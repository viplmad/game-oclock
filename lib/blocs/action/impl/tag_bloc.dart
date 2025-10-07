import 'package:game_oclock/models/models.dart' show Tag;
import 'package:game_oclock/services/services.dart' show TagService;

import '../action.dart'
    show ActionFinal, ActionSuccess, ConsumerActionBloc, FunctionActionBloc;

class TagGetBloc extends FunctionActionBloc<String, Tag> {
  TagGetBloc({required this.service});

  final TagService service;

  @override
  Future<ActionFinal<Tag, String>> doAction(
    final String event,
    final Tag? lastData,
  ) async {
    final data = await service.get(event);
    return ActionSuccess(data: data, event: event);
  }
}

class TagCreateBloc extends ConsumerActionBloc<Tag> {
  TagCreateBloc({required this.service});

  final TagService service;

  @override
  Future<ActionFinal<void, Tag>> doAction(
    final Tag event,
    final void lastData,
  ) async {
    await service.create(event);
    return ActionSuccess.consumer(event);
  }
}

class TagUpdateBloc extends ConsumerActionBloc<Tag> {
  TagUpdateBloc({required this.service});

  final TagService service;

  @override
  Future<ActionFinal<void, Tag>> doAction(
    final Tag event,
    final void lastData,
  ) async {
    await service.update(event);
    return ActionSuccess.consumer(event);
  }
}

class TagDeleteBloc extends ConsumerActionBloc<Tag> {
  TagDeleteBloc({required this.service});

  final TagService service;

  @override
  Future<ActionFinal<void, Tag>> doAction(
    final Tag event,
    final void lastData,
  ) async {
    await service.delete(event.id);
    return ActionSuccess.consumer(event);
  }
}

class TagSelectBloc extends FunctionActionBloc<Tag?, Tag?> {
  @override
  Future<ActionFinal<Tag?, Tag?>> doAction(
    final Tag? event,
    final Tag? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
