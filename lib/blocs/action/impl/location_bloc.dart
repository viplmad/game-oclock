import 'package:game_oclock/models/models.dart' show Location;
import 'package:game_oclock/services/services.dart' show LocationService;

import '../action.dart'
    show
        ActionFinal,
        ActionSuccess,
        ConsumerActionBloc,
        FunctionActionBloc,
        IdentityActionBloc;

class LocationGetBloc extends FunctionActionBloc<String, Location> {
  LocationGetBloc({required this.service});

  final LocationService service;

  @override
  Future<ActionFinal<Location, String>> doAction(
    final String event,
    final Location? lastData,
  ) async {
    final data = await service.get(event);
    return ActionSuccess(data: data, event: event);
  }
}

class LocationCreateBloc extends IdentityActionBloc<Location> {
  LocationCreateBloc({required this.service});

  final LocationService service;

  @override
  Future<ActionFinal<Location, Location>> doAction(
    final Location event,
    final Location? lastData,
  ) async {
    final data = await service.create(event);
    return ActionSuccess(data: data, event: event);
  }
}

class LocationUpdateBloc extends ConsumerActionBloc<Location> {
  LocationUpdateBloc({required this.service});

  final LocationService service;

  @override
  Future<ActionFinal<void, Location>> doAction(
    final Location event,
    final void lastData,
  ) async {
    await service.update(event);
    return ActionSuccess.consumer(event);
  }
}

class LocationDeleteBloc extends ConsumerActionBloc<Location> {
  LocationDeleteBloc({required this.service});

  final LocationService service;

  @override
  Future<ActionFinal<void, Location>> doAction(
    final Location event,
    final void lastData,
  ) async {
    await service.delete(event.id);
    return ActionSuccess.consumer(event);
  }
}

class LocationSelectBloc extends IdentityActionBloc<Location?> {
  @override
  Future<ActionFinal<Location?, Location?>> doAction(
    final Location? event,
    final Location? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
