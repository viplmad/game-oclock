import 'package:game_oclock/models/models.dart' show Tag;
import 'package:game_oclock/services/services.dart' show TagService;

import '../action.dart' show ActionFinal, ActionSuccess, ConsumerActionBloc;

class TagCreateBloc extends ConsumerActionBloc<Tag> {
  TagCreateBloc({required this.service});

  final TagService service;

  @override
  Future<ActionFinal<void, Tag>> doAction(
    final Tag event,
    final void lastData,
  ) async {
    await service.create(event);
    return ActionSuccess.consumer(event);
  }
}
