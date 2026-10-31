import 'package:game_oclock/services/services.dart' show TagService;
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class TagGetBloc extends FunctionActionBloc<String, TagDTO> {
  TagGetBloc({required this.service});

  final TagService service;

  @override
  Future<TagDTO> doAction(String event, TagDTO? lastData) => service.get(event);
}

class TagCreateBloc extends FunctionActionBloc<NewTagDTO, String> {
  TagCreateBloc({required this.service});

  final TagService service;

  @override
  Future<String> doAction(NewTagDTO event, String? lastData) =>
      service.create(event);
}

class TagUpdateBloc extends ConsumerActionBloc<NewTagDTO> {
  TagUpdateBloc({required this.service, required this.id});

  final TagService service;
  final String id;

  @override
  Future<void> doAction(NewTagDTO event, void lastData) =>
      service.update(id, event);
}

class TagDeleteBloc extends ConsumerActionBloc<TagDTO> {
  TagDeleteBloc({required this.service});

  final TagService service;

  @override
  Future<void> doAction(TagDTO event, void lastData) =>
      service.delete(event.id);
}

class TagSelectBloc extends IdentityActionBloc<TagDTO?> {
  @override
  Future<TagDTO?> doAction(TagDTO? event, TagDTO? lastData) async => event;
}
