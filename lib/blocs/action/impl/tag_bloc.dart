import 'package:game_oclock/services/services.dart' show TagService;
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class TagGetBloc extends FunctionActionBloc<String, TagDTO> {
  TagGetBloc({required this.service});

  final TagService service;

  @override
  Future<TagDTO> doAction(final String event, final TagDTO? lastData) =>
      service.get(event);
}

class TagCreateBloc extends FunctionActionBloc<NewTagDTO, String> {
  TagCreateBloc({required this.service});

  final TagService service;

  @override
  Future<String> doAction(final NewTagDTO event, final String? lastData) =>
      service.create(event);
}

class TagUpdateBloc extends ConsumerActionBloc<NewTagDTO> {
  TagUpdateBloc({required this.service, required this.id});

  final TagService service;
  final String id;

  @override
  Future<void> doAction(final NewTagDTO event, final void lastData) =>
      service.update(id, event);
}

class TagDeleteBloc extends ConsumerActionBloc<TagDTO> {
  TagDeleteBloc({required this.service});

  final TagService service;

  @override
  Future<void> doAction(final TagDTO event, final void lastData) =>
      service.delete(event.id);
}

class TagSelectBloc extends IdentityActionBloc<TagDTO?> {
  @override
  Future<TagDTO?> doAction(final TagDTO? event, final TagDTO? lastData) async =>
      event;
}
