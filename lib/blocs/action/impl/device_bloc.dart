import 'package:game_oclock/models/models.dart' show Device;
import 'package:game_oclock/services/services.dart' show DeviceService;

import '../action.dart'
    show
        ActionFinal,
        ActionSuccess,
        ConsumerActionBloc,
        FunctionActionBloc,
        IdentityActionBloc;

class DeviceGetBloc extends FunctionActionBloc<String, Device> {
  DeviceGetBloc({required this.service});

  final DeviceService service;

  @override
  Future<ActionFinal<Device, String>> doAction(
    final String event,
    final Device? lastData,
  ) async {
    final data = await service.get(event);
    return ActionSuccess(data: data, event: event);
  }
}

class DeviceCreateBloc extends IdentityActionBloc<Device> {
  DeviceCreateBloc({required this.service});

  final DeviceService service;

  @override
  Future<ActionFinal<Device, Device>> doAction(
    final Device event,
    final Device? lastData,
  ) async {
    final data = await service.create(event);
    return ActionSuccess(data: data, event: event);
  }
}

class DeviceUpdateBloc extends ConsumerActionBloc<Device> {
  DeviceUpdateBloc({required this.service});

  final DeviceService service;

  @override
  Future<ActionFinal<void, Device>> doAction(
    final Device event,
    final void lastData,
  ) async {
    await service.update(event);
    return ActionSuccess.consumer(event);
  }
}

class DeviceDeleteBloc extends ConsumerActionBloc<Device> {
  DeviceDeleteBloc({required this.service});

  final DeviceService service;

  @override
  Future<ActionFinal<void, Device>> doAction(
    final Device event,
    final void lastData,
  ) async {
    await service.delete(event.id);
    return ActionSuccess.consumer(event);
  }
}

class DeviceSelectBloc extends IdentityActionBloc<Device?> {
  @override
  Future<ActionFinal<Device?, Device?>> doAction(
    final Device? event,
    final Device? lastData,
  ) async {
    return ActionSuccess(data: event, event: event);
  }
}
