import 'package:game_oclock/models/models.dart' show Device;
import 'package:game_oclock/services/services.dart' show DeviceService;

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class DeviceGetBloc extends FunctionActionBloc<String, Device> {
  DeviceGetBloc({required this.service});

  final DeviceService service;

  @override
  Future<Device> doAction(final String event, final Device? lastData) =>
      service.get(event);
}

class DeviceCreateBloc extends IdentityActionBloc<Device> {
  DeviceCreateBloc({required this.service});

  final DeviceService service;

  @override
  Future<Device> doAction(final Device event, final Device? lastData) =>
      service.create(event);
}

class DeviceUpdateBloc extends ConsumerActionBloc<Device> {
  DeviceUpdateBloc({required this.service});

  final DeviceService service;

  @override
  Future<void> doAction(final Device event, final void lastData) =>
      service.update(event);
}

class DeviceDeleteBloc extends ConsumerActionBloc<Device> {
  DeviceDeleteBloc({required this.service});

  final DeviceService service;

  @override
  Future<void> doAction(final Device event, final void lastData) =>
      service.delete(event.id);
}

class DeviceSelectBloc extends IdentityActionBloc<Device?> {
  @override
  Future<Device?> doAction(final Device? event, final Device? lastData) async =>
      event;
}
