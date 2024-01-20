import 'package:equatable/equatable.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

abstract class ConnectState extends Equatable {
  const ConnectState();

  @override
  List<Object> get props => <Object>[];
}

class Connecting extends ConnectState {}

class Connected extends ConnectState {}

class NonexistentConnection extends ConnectState {}

class FailedConnection extends ConnectState {
  const FailedConnection(this.error, this.errorDescription);

  final ErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'FailedConnection { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
