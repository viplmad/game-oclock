import 'package:equatable/equatable.dart';

import 'package:backend/model/model.dart' show ServerConnection;

abstract class ServerSettingsState extends Equatable {
  const ServerSettingsState();

  @override
  List<Object> get props => <Object>[];
}

class ServerSettingsLoading extends ServerSettingsState {}

class ServerSettingsLoaded extends ServerSettingsState {
  const ServerSettingsLoaded([
    this.activeServerConnection,
  ]);

  final ServerConnection? activeServerConnection;

  @override
  List<Object> get props => <Object>[activeServerConnection ?? ''];

  @override
  String toString() => 'ServerSettingsLoaded { '
      'activeServerConnection: $activeServerConnection'
      ' }';
}

class ServerSettingsNotLoaded extends ServerSettingsState {
  const ServerSettingsNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'ServerSettingsNotLoaded { '
      'error: $error'
      ' }';
}
