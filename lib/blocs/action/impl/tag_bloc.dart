import 'package:game_oclock/models/models.dart' show Tag;
import 'package:game_oclock/services/services.dart' show TagService;

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class TagGetBloc extends FunctionActionBloc<String, Tag> {
  TagGetBloc({required this.service});

  final TagService service;

  @override
  Future<Tag> doAction(final String event, final Tag? lastData) =>
      service.get(event);
}

class TagCreateBloc extends IdentityActionBloc<Tag> {
  TagCreateBloc({required this.service});

  final TagService service;

  @override
  Future<Tag> doAction(final Tag event, final Tag? lastData) =>
      service.create(event);
}

class TagUpdateBloc extends ConsumerActionBloc<Tag> {
  TagUpdateBloc({required this.service});

  final TagService service;

  @override
  Future<void> doAction(final Tag event, final void lastData) =>
      service.update(event);
}

class TagDeleteBloc extends ConsumerActionBloc<Tag> {
  TagDeleteBloc({required this.service});

  final TagService service;

  @override
  Future<void> doAction(final Tag event, final void lastData) =>
      service.delete(event.id);
}

class TagSelectBloc extends IdentityActionBloc<Tag?> {
  @override
  Future<Tag?> doAction(final Tag? event, final Tag? lastData) async => event;
}
