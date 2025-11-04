import 'package:game_oclock/models/models.dart'
    show ErrorDTO, ListStyle, defaultListStyle, errorCodeNotFound;
import 'package:game_oclock/services/services.dart' show ListStyleService;

import '../action.dart'
    show
        ActionFailure,
        ActionFinal,
        ActionSuccess,
        IdentityActionBloc,
        ProducerActionBloc;

class ListStyleGetBloc extends ProducerActionBloc<ListStyle> {
  ListStyleGetBloc({required this.service, required this.space});

  final ListStyleService service;
  final String space;

  @override
  Future<ActionFinal<ListStyle, void>> doAction(
    final void event,
    final ListStyle? lastData,
  ) async {
    final data = await service.get(space);
    return data == null
        ? ActionFailure.producer(
            const ErrorDTO(
              code: errorCodeNotFound,
              message: 'No ListStyle saved',
            ),
            defaultListStyle,
          )
        : ActionSuccess.producer(data);
  }
}

class ListStyleSaveBloc extends IdentityActionBloc<ListStyle> {
  ListStyleSaveBloc({required this.service, required this.space});

  final ListStyleService service;
  final String space;

  @override
  Future<ActionFinal<ListStyle, ListStyle>> doAction(
    final ListStyle event,
    final ListStyle? lastData,
  ) async {
    await service.save(space, event);
    return ActionSuccess(data: event, event: event);
  }
}
