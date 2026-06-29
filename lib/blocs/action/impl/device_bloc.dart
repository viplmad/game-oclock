import 'package:game_oclock/services/services.dart' show DeviceService;
import 'package:game_oclock_client/api.dart';

import '../action.dart'
    show ConsumerActionBloc, FunctionActionBloc, IdentityActionBloc;

class DeviceGetBloc extends FunctionActionBloc<String, DeviceDTO> {
  DeviceGetBloc({required this.service, final bool cache = false})
    : cache = cache ? <String, DeviceDTO>{} : null;

  final DeviceService service;
  final Map<String, DeviceDTO>? cache;

  @override
  Future<DeviceDTO> doAction(
    final String event,
    final DeviceDTO? lastData,
  ) async => cache?[event] ?? service.get(event);
}

class DeviceCreateBloc extends FunctionActionBloc<NewDeviceDTO, String> {
  DeviceCreateBloc({required this.service});

  final DeviceService service;

  @override
  Future<String> doAction(final NewDeviceDTO event, final String? lastData) =>
      service.create(event);
}

class DeviceUpdateBloc extends ConsumerActionBloc<NewDeviceDTO> {
  DeviceUpdateBloc({required this.service, required this.id});

  final DeviceService service;
  final String id;

  @override
  Future<void> doAction(final NewDeviceDTO event, final void lastData) =>
      service.update(id, event);
}

class DeviceDeleteBloc extends ConsumerActionBloc<DeviceDTO> {
  DeviceDeleteBloc({required this.service});

  final DeviceService service;

  @override
  Future<void> doAction(final DeviceDTO event, final void lastData) =>
      service.delete(event.id);
}

class DeviceSelectBloc extends IdentityActionBloc<DeviceDTO?> {
  @override
  Future<DeviceDTO?> doAction(
    final DeviceDTO? event,
    final DeviceDTO? lastData,
  ) async => event;
}
