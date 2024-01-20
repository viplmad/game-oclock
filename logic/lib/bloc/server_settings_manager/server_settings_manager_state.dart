import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

import 'package:logic/model/model.dart' show ServerConnection;

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
  const ServerSettingsNotSaved(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ServerSettingsNotSaved { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}

class ServerSettingsNotLoaded extends ServerSettingsManagerState {
  const ServerSettingsNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'ServerSettingsNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
