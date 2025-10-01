import 'package:game_oclock/models/models.dart' show Location;
import 'package:game_oclock/services/services.dart' show LocationService;

import '../action.dart' show ActionFinal, ActionSuccess, ConsumerActionBloc;

class LocationCreateBloc extends ConsumerActionBloc<Location> {
  LocationCreateBloc({required this.service});

  final LocationService service;

  @override
  Future<ActionFinal<void, Location>> doAction(
    final Location event,
    final void lastData,
  ) async {
    await service.create(event);
    return ActionSuccess.consumer(event);
  }
}
