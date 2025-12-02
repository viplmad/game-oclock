import 'package:game_oclock/models/models.dart' show ListStyle;
import 'package:game_oclock/services/services.dart' show ListStyleService;

import '../action.dart' show ConsumerActionBloc, ProducerActionBloc;

class CurrentListStyleGetBloc extends ProducerActionBloc<ListStyle> {
  CurrentListStyleGetBloc({required this.service, required this.space});

  final ListStyleService service;
  final String space;

  @override
  Future<ListStyle> doAction(final void event, final ListStyle? lastData) =>
      service.getCurrent(space);
}

class CurrentListStyleSaveBloc extends ConsumerActionBloc<ListStyle?> {
  CurrentListStyleSaveBloc({required this.service, required this.space});

  final ListStyleService service;
  final String space;

  @override
  Future<void> doAction(final ListStyle? event, final void lastData) =>
      event == null
      ? service.removeCurrent(space)
      : service.saveCurrent(space, event);
}
