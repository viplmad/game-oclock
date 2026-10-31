import 'package:game_oclock/services/services.dart' show DeviceService;
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class DeviceGetBloc extends FunctionActionBloc<String, DeviceDTO> {
  DeviceGetBloc({required this.service, bool cache = false})
    : cache = cache ? <String, DeviceDTO>{} : null;

  final DeviceService service;
  final Map<String, DeviceDTO>? cache;

  @override
  Future<DeviceDTO> doAction(String event, DeviceDTO? lastData) async =>
      cache?[event] ?? service.get(event);
}

class DeviceCreateBloc extends FunctionActionBloc<NewDeviceDTO, String> {
  DeviceCreateBloc({required this.service});

  final DeviceService service;

  @override
  Future<String> doAction(NewDeviceDTO event, String? lastData) =>
      service.create(event);
}

class DeviceUpdateBloc extends ConsumerActionBloc<NewDeviceDTO> {
  DeviceUpdateBloc({required this.service, required this.id});

  final DeviceService service;
  final String id;

  @override
  Future<void> doAction(NewDeviceDTO event, void lastData) =>
      service.update(id, event);
}

class DeviceDeleteBloc extends ConsumerActionBloc<DeviceDTO> {
  DeviceDeleteBloc({required this.service});

  final DeviceService service;

  @override
  Future<void> doAction(DeviceDTO event, void lastData) =>
      service.delete(event.id);
}

class DeviceSelectBloc extends IdentityActionBloc<DeviceDTO?> {
  @override
  Future<DeviceDTO?> doAction(DeviceDTO? event, DeviceDTO? lastData) async =>
      event;
}
