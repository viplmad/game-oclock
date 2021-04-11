import 'package:equatable/equatable.dart';


abstract class ConnectState extends Equatable {
  const ConnectState();

  @override
  List<Object> get props => <Object>[];
}

class Connecting extends ConnectState {}

class Connected extends ConnectState {}

class NonexistentConnection extends ConnectState {}

class FailedConnection extends ConnectState {
  const FailedConnection(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'FailedConnection { '
      'error: $error'
      ' }';
}