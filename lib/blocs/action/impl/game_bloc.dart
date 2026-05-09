import 'package:game_oclock/services/services.dart' show GameService;
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class UserGameGetBloc extends FunctionActionBloc<String, MediaDTO> {
  UserGameGetBloc({required this.service});

  final GameService service;

  @override
  Future<MediaDTO> doAction(final String event, final MediaDTO? lastData) =>
      service.get(event);
}

class UserGameCreateBloc extends FunctionActionBloc<NewMediaDTO, String> {
  UserGameCreateBloc({required this.service});

  final GameService service;

  @override
  Future<String> doAction(final NewMediaDTO event, final String? lastData) =>
      service.create(event);
}

class UserGameUpdateBloc extends ConsumerActionBloc<NewMediaDTO> {
  UserGameUpdateBloc({required this.service, required this.id});

  final GameService service;
  final String id;

  @override
  Future<void> doAction(final NewMediaDTO event, final void lastData) =>
      service.update(id, event);
}

class UserGameDeleteBloc extends ConsumerActionBloc<MediaDTO> {
  UserGameDeleteBloc({required this.service});

  final GameService service;

  @override
  Future<void> doAction(final MediaDTO event, final void lastData) =>
      service.delete(event.media.id);
}

class UserGameSelectBloc extends IdentityActionBloc<MediaDTO?> {
  @override
  Future<MediaDTO?> doAction(
    final MediaDTO? event,
    final MediaDTO? lastData,
  ) async => event;
}
