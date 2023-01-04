import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart' show ServerConnection;

abstract class ServerSettingsManagerState extends Equatable {
  const ServerSettingsManagerState();

  @override
  List<Object> get props => <Object>[];
}

class Initialised extends ServerSettingsManagerState {}

class ServerConnectionSettingsSaved extends ServerSettingsManagerState {
  const ServerConnectionSettingsSaved(this.connection);

  final ServerConnection connection;

  @override
  List<Object> get props => <Object>[connection];

  @override
  String toString() => 'ServerConnectionSettingsSaved { '
      'connection: $connection'
      ' }';
}

class ServerSettingsNotSaved extends ServerSettingsManagerState {
  const ServerSettingsNotSaved(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ServerSettingsNotSaved { '
      'error: $error'
      ' }';
}
