import 'package:game_oclock/services/services.dart' show LocationService;
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class LocationGetBloc extends FunctionActionBloc<String, LocationDTO> {
  LocationGetBloc({required this.service});

  final LocationService service;

  @override
  Future<LocationDTO> doAction(
    final String event,
    final LocationDTO? lastData,
  ) => service.get(event);
}

class LocationCreateBloc extends FunctionActionBloc<NewLocationDTO, String> {
  LocationCreateBloc({required this.service});

  final LocationService service;

  @override
  Future<String> doAction(final NewLocationDTO event, final String? lastData) =>
      service.create(event);
}

class LocationUpdateBloc extends ConsumerActionBloc<NewLocationDTO> {
  LocationUpdateBloc({required this.service, required this.id});

  final LocationService service;
  final String id;

  @override
  Future<void> doAction(final NewLocationDTO event, final void lastData) =>
      service.update(id, event);
}

class LocationDeleteBloc extends ConsumerActionBloc<LocationDTO> {
  LocationDeleteBloc({required this.service});

  final LocationService service;

  @override
  Future<void> doAction(final LocationDTO event, final void lastData) =>
      service.delete(event.id);
}

class LocationSelectBloc extends IdentityActionBloc<LocationDTO?> {
  @override
  Future<LocationDTO?> doAction(
    final LocationDTO? event,
    final LocationDTO? lastData,
  ) async => event;
}
