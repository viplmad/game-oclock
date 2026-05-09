import 'package:game_oclock/models/models.dart' show Playthrough;
import 'package:game_oclock/services/services.dart' show PlaythroughService;

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class PlaythroughGetBloc extends FunctionActionBloc<String, Playthrough> {
  PlaythroughGetBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<Playthrough> doAction(
    final String event,
    final Playthrough? lastData,
  ) => service.get(event);
}

class PlaythroughCreateBloc extends FunctionActionBloc<Playthrough, String> {
  PlaythroughCreateBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<String> doAction(final Playthrough event, final String? lastData) =>
      service.create(event);
}

class PlaythroughUpdateBloc extends ConsumerActionBloc<Playthrough> {
  PlaythroughUpdateBloc({required this.service, required this.id});

  final PlaythroughService service;
  final String id;

  @override
  Future<void> doAction(final Playthrough event, final void lastData) =>
      service.update(id, event);
}

class PlaythroughDeleteBloc extends ConsumerActionBloc<Playthrough> {
  PlaythroughDeleteBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<void> doAction(final Playthrough event, final void lastData) =>
      service.delete(event.id);
}

class PlaythroughSelectBloc extends IdentityActionBloc<Playthrough?> {
  @override
  Future<Playthrough?> doAction(
    final Playthrough? event,
    final Playthrough? lastData,
  ) async => event;
}
