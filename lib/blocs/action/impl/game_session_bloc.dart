import 'package:game_oclock/models/models.dart'
    show AggregateSearch, NewMediaSession, startDateField;
import 'package:game_oclock/services/services.dart' show SessionService;
import 'package:game_oclock/utils/filter_utils.dart';
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

class UserGameTotalTimeGetBloc extends FunctionActionBloc<String, Duration> {
  UserGameTotalTimeGetBloc({required this.service});

  final SessionService service;

  @override
  Future<Duration> doAction(final String event, final Duration? lastData) =>
      service.sumTimeForGame(event, AggregateSearch(), null);
}

class UserGameFinishesGetBloc
    extends FunctionActionBloc<String, List<SessionDTO>> {
  UserGameFinishesGetBloc({required this.service});

  final SessionService service;

  @override
  Future<List<SessionDTO>> doAction(
    final String event,
    final List<SessionDTO>? lastData,
  ) async {
    final data = await service.searchForGame(
      event,
      ListSearchDTO(
        filter: List.unmodifiable(<FilterDTO>[buildFinishedFilter()]),
        sort: List.unmodifiable(<SortDTO>[
          // Show first finishes first
          SortDTO(field: startDateField.value, order: OrderType.asc),
        ]),
      ),
      null,
    );
    return data.data;
  }
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
