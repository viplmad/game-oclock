import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart' show ServerConnection;

abstract class ServerSettingsEvent extends Equatable {
  const ServerSettingsEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadServerSettings extends ServerSettingsEvent {}

class UpdateServerSettings extends ServerSettingsEvent {
  const UpdateServerSettings(
    this.savedServerConnection,
  );

  final ServerConnection? savedServerConnection;

  @override
  List<Object> get props => <Object>[savedServerConnection ?? ''];

  @override
  String toString() => 'UpdateServerSettings { '
      'savedServerConnection: $savedServerConnection, '
      ' }';
}
