import 'package:game_oclock/models/models.dart' show NewMediaSession;
import 'package:game_oclock/services/services.dart' show GameSessionService;
import 'package:game_oclock_client/api.dart';

import '../action.dart' show FunctionActionBloc, IdentityActionBloc;

class GameSessionCreateBloc
    extends FunctionActionBloc<NewMediaSession, (String, DateTime)> {
  GameSessionCreateBloc({required this.service});

  final GameSessionService service;

  @override
  Future<(String, DateTime)> doAction(
    final NewMediaSession event,
    final (String, DateTime)? lastData,
  ) => service
      .create(event.gameId, event as NewSessionDTO)
      .then((_) => (event.gameId, event.startDatetime));
}

class GameSessionSelectBloc extends IdentityActionBloc<SessionDTO?> {
  @override
  Future<SessionDTO?> doAction(
    final SessionDTO? event,
    final SessionDTO? lastData,
  ) async => event;
}
