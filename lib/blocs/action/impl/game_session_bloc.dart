import 'package:game_oclock/models/models.dart' show NewMediaSession;
import 'package:game_oclock/services/services.dart' show SessionService;
import 'package:game_oclock_client/api.dart';

import '../action.dart' show FunctionActionBloc, IdentityActionBloc;

class SessionCreateBloc
    extends FunctionActionBloc<NewMediaSession, (String, DateTime)> {
  SessionCreateBloc({required this.service});

  final SessionService service;

  @override
  Future<(String, DateTime)> doAction(
    final NewMediaSession event,
    final (String, DateTime)? lastData,
  ) => service
      .create(event.gameId, event as NewSessionDTO)
      .then((_) => (event.gameId, event.startDatetime));
}

class SessionSelectBloc extends IdentityActionBloc<SessionDTO?> {
  @override
  Future<SessionDTO?> doAction(
    final SessionDTO? event,
    final SessionDTO? lastData,
  ) async => event;
}

class SessionWithMediaSelectBloc extends IdentityActionBloc<MediaSessionDTO?> {
  @override
  Future<MediaSessionDTO?> doAction(
    final MediaSessionDTO? event,
    final MediaSessionDTO? lastData,
  ) async => event;
}
