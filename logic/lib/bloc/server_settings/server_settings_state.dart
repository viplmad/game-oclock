import 'package:equatable/equatable.dart';

import 'package:logic/model/model.dart' show ServerConnection;

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

class ServerSettingsError extends ServerSettingsState {}
