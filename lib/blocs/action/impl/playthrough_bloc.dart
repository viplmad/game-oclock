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

class PlaythroughCreateBloc extends IdentityActionBloc<Playthrough> {
  PlaythroughCreateBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<Playthrough> doAction(
    final Playthrough event,
    final Playthrough? lastData,
  ) => service.create(event);
}

class PlaythroughUpdateBloc extends ConsumerActionBloc<Playthrough> {
  PlaythroughUpdateBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<void> doAction(final Playthrough event, final void lastData) =>
      service.update(event);
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
