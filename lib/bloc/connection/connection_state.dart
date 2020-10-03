import 'package:equatable/equatable.dart';


abstract class ConnectState extends Equatable {
  const ConnectState();

  @override
  List<Object> get props => [];
}

class Uninitialised extends ConnectState {}

class Connecting extends ConnectState {}

class Connected extends ConnectState {}

class FailedConnection extends ConnectState {
  const FailedConnection(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FailedConnection { '
      'error: $error'
      ' }';
}