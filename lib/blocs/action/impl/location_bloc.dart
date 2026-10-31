import 'package:game_oclock/services/services.dart' show LocationService;
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class LocationGetBloc extends FunctionActionBloc<String, LocationDTO> {
  LocationGetBloc({required this.service});

  final LocationService service;

  @override
  Future<LocationDTO> doAction(String event, LocationDTO? lastData) =>
      service.get(event);
}

class LocationCreateBloc extends FunctionActionBloc<NewLocationDTO, String> {
  LocationCreateBloc({required this.service});

  final LocationService service;

  @override
  Future<String> doAction(NewLocationDTO event, String? lastData) =>
      service.create(event);
}

class LocationUpdateBloc extends ConsumerActionBloc<NewLocationDTO> {
  LocationUpdateBloc({required this.service, required this.id});

  final LocationService service;
  final String id;

  @override
  Future<void> doAction(NewLocationDTO event, void lastData) =>
      service.update(id, event);
}

class LocationDeleteBloc extends ConsumerActionBloc<LocationDTO> {
  LocationDeleteBloc({required this.service});

  final LocationService service;

  @override
  Future<void> doAction(LocationDTO event, void lastData) =>
      service.delete(event.id);
}

class LocationSelectBloc extends IdentityActionBloc<LocationDTO?> {
  @override
  Future<LocationDTO?> doAction(
    LocationDTO? event,
    LocationDTO? lastData,
  ) async => event;
}
