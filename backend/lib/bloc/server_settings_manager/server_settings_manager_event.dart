import 'package:equatable/equatable.dart';

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
