import 'package:game_oclock/models/models.dart' show GamePlaythrough;
import 'package:game_oclock/services/services.dart' show GamePlaythroughService;

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class GamePlaythroughGetBloc
    extends FunctionActionBloc<String, GamePlaythrough> {
  GamePlaythroughGetBloc({required this.service});

  final GamePlaythroughService service;

  @override
  Future<GamePlaythrough> doAction(
    final String event,
    final GamePlaythrough? lastData,
  ) => service.get(event);
}

class GamePlaythroughCreateBloc extends IdentityActionBloc<GamePlaythrough> {
  GamePlaythroughCreateBloc({required this.service});

  final GamePlaythroughService service;

  @override
  Future<GamePlaythrough> doAction(
    final GamePlaythrough event,
    final GamePlaythrough? lastData,
  ) => service.create(event);
}

class GamePlaythroughUpdateBloc extends ConsumerActionBloc<GamePlaythrough> {
  GamePlaythroughUpdateBloc({required this.service});

  final GamePlaythroughService service;

  @override
  Future<void> doAction(final GamePlaythrough event, final void lastData) =>
      service.update(event);
}
