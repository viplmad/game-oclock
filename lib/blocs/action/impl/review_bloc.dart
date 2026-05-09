import 'package:game_oclock/services/services.dart' show GameSessionService;
import 'package:game_oclock_client/api.dart';

import '../action.dart' show FunctionActionBloc, IdentityActionBloc;

class ReviewYearSelectBloc extends IdentityActionBloc<int?> {
  @override
  Future<int?> doAction(final int? event, final int? lastData) async => event;
}

class ReviewTotalSessionsGetBloc
    extends FunctionActionBloc<ListSearchDTO, int> {
  ReviewTotalSessionsGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ListSearchDTO event, final int? lastData) =>
      service.count(event, null);
}

class ReviewTotalTimeGetBloc
    extends FunctionActionBloc<ListSearchDTO, Duration> {
  ReviewTotalTimeGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<Duration> doAction(
    final ListSearchDTO event,
    final Duration? lastData,
  ) => service.sumTime(event, null);
}

class ReviewTotalMediasGetBloc extends FunctionActionBloc<ListSearchDTO, int> {
  ReviewTotalMediasGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ListSearchDTO event, final int? lastData) =>
      service.countDistinctMedias(event, null);
}

class ReviewTotalFirstMediasGetBloc
    extends FunctionActionBloc<ListSearchDTO, int> {
  ReviewTotalFirstMediasGetBloc({required this.service});

  final GameSessionService service;

  @override
  Future<int> doAction(final ListSearchDTO event, final int? lastData) =>
      service.countDistinctFirstTimeMedias(event, null);
}
