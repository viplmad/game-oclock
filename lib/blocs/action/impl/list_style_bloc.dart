import 'package:game_oclock/models/models.dart'
    show ListStyle, defaultListStyle;
import 'package:game_oclock/services/services.dart' show ListStyleService;

import '../action.dart' show ConsumerActionBloc, ProducerActionBloc;

class ListStyleGetBloc extends ProducerActionBloc<ListStyle> {
  ListStyleGetBloc({required this.service, required this.space});

  final ListStyleService service;
  final String space;

  @override
  Future<ListStyle> doAction(final void event, final ListStyle? lastData) =>
      service.get(space).then((final value) => value ?? defaultListStyle);
}

class ListStyleSaveBloc extends ConsumerActionBloc<ListStyle> {
  ListStyleSaveBloc({required this.service, required this.space});

  final ListStyleService service;
  final String space;

  @override
  Future<void> doAction(final ListStyle event, final void lastData) =>
      service.save(space, event);
}
