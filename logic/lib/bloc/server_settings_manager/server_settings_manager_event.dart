import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

abstract class ServerSettingsManagerEvent extends Equatable {
  const ServerSettingsManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class SaveServerConnectionSettings extends ServerSettingsManagerEvent {
  const SaveServerConnectionSettings(
    this.name,
    this.host,
    this.username,
    this.password,
  );

  final String name;
  final String host;
  final String username;
  final String password;

  @override
  List<Object> get props => <Object>[name, host, username, password];

  @override
  String toString() => 'SaveServerConnectionSettings { '
      'name: $name, '
      'host: $host, '
      'username: $username, '
      'password: $password'
      ' }';
}

class WarnServerSettingsNotLoaded extends ServerSettingsManagerEvent {
  const WarnServerSettingsNotLoaded(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'WarnServerSettingsNotLoaded { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
