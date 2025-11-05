import 'package:game_oclock/models/models.dart' show Location;
import 'package:game_oclock/services/services.dart' show LocationService;

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class LocationGetBloc extends FunctionActionBloc<String, Location> {
  LocationGetBloc({required this.service});

  final LocationService service;

  @override
  Future<Location> doAction(final String event, final Location? lastData) =>
      service.get(event);
}

class LocationCreateBloc extends IdentityActionBloc<Location> {
  LocationCreateBloc({required this.service});

  final LocationService service;

  @override
  Future<Location> doAction(final Location event, final Location? lastData) =>
      service.create(event);
}

class LocationUpdateBloc extends ConsumerActionBloc<Location> {
  LocationUpdateBloc({required this.service});

  final LocationService service;

  @override
  Future<void> doAction(final Location event, final void lastData) =>
      service.update(event);
}

class LocationDeleteBloc extends ConsumerActionBloc<Location> {
  LocationDeleteBloc({required this.service});

  final LocationService service;

  @override
  Future<void> doAction(final Location event, final void lastData) =>
      service.delete(event.id);
}

class LocationSelectBloc extends IdentityActionBloc<Location?> {
  @override
  Future<Location?> doAction(
    final Location? event,
    final Location? lastData,
  ) async => event;
}
