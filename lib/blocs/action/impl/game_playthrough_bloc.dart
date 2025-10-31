import 'package:game_oclock/models/models.dart' show GamePlaythrough;
import 'package:game_oclock/services/services.dart' show GamePlaythroughService;

import '../action.dart'
    show
        ActionFinal,
        ActionSuccess,
        ConsumerActionBloc,
        FunctionActionBloc,
        IdentityActionBloc;

class GamePlaythroughGetBloc
    extends FunctionActionBloc<String, GamePlaythrough> {
  GamePlaythroughGetBloc({required this.service});

  final GamePlaythroughService service;

  @override
  Future<ActionFinal<GamePlaythrough, String>> doAction(
    final String event,
    final GamePlaythrough? lastData,
  ) async {
    final data = await service.get(event);
    return ActionSuccess(data: data, event: event);
  }
}

class GamePlaythroughCreateBloc extends IdentityActionBloc<GamePlaythrough> {
  GamePlaythroughCreateBloc({required this.service});

  final GamePlaythroughService service;

  @override
  Future<ActionFinal<GamePlaythrough, GamePlaythrough>> doAction(
    final GamePlaythrough event,
    final GamePlaythrough? lastData,
  ) async {
    final data = await service.create(event);
    return ActionSuccess(data: data, event: event);
  }
}

class GamePlaythroughUpdateBloc extends ConsumerActionBloc<GamePlaythrough> {
  GamePlaythroughUpdateBloc({required this.service});

  final GamePlaythroughService service;

  @override
  Future<ActionFinal<void, GamePlaythrough>> doAction(
    final GamePlaythrough event,
    final void lastData,
  ) async {
    await service.update(event);
    return ActionSuccess.consumer(event);
  }
}
