import 'package:game_oclock/models/models.dart' show ListStyle;
import 'package:game_oclock/services/services.dart' show ListStyleService;

import '../action.dart' show ActionFinal, ActionSuccess, IdentityActionBloc;

class ListStyleBloc extends IdentityActionBloc<ListStyle> {
  ListStyleBloc({required this.service, required this.space});

  final ListStyleService service;
  final String space;

  @override
  Future<ActionFinal<ListStyle, ListStyle>?> doStored(
    final ListStyle? lastData,
  ) async {
    final data = await service.get(space);
    return data == null ? null : ActionSuccess(data: data, event: data);
  }

  @override
  Future<ActionFinal<ListStyle, ListStyle>> doAction(
    final ListStyle event,
    final ListStyle? lastData,
  ) async {
    await service.save(space, event);
    return ActionSuccess(data: event, event: event);
  }
}
