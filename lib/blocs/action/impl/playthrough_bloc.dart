import 'package:game_oclock/models/models.dart'
    show NewPlaythrough, Playthrough;
import 'package:game_oclock/services/services.dart' show PlaythroughService;

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class PlaythroughGetBloc extends FunctionActionBloc<String, Playthrough> {
  PlaythroughGetBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<Playthrough> doAction(String event, Playthrough? lastData) =>
      service.get(event);
}

class PlaythroughCreateBloc extends FunctionActionBloc<NewPlaythrough, String> {
  PlaythroughCreateBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<String> doAction(NewPlaythrough event, String? lastData) =>
      service.create(event);
}

class PlaythroughUpdateBloc extends ConsumerActionBloc<NewPlaythrough> {
  PlaythroughUpdateBloc({required this.service, required this.id});

  final PlaythroughService service;
  final String id;

  @override
  Future<void> doAction(NewPlaythrough event, void lastData) =>
      service.update(id, event);
}

class PlaythroughDeleteBloc extends ConsumerActionBloc<Playthrough> {
  PlaythroughDeleteBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<void> doAction(Playthrough event, void lastData) =>
      service.delete(event.id);
}

class PlaythroughSelectBloc extends IdentityActionBloc<Playthrough?> {
  @override
  Future<Playthrough?> doAction(
    Playthrough? event,
    Playthrough? lastData,
  ) async => event;
}
