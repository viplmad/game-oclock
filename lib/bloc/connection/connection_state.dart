import 'package:equatable/equatable.dart';


abstract class ConnectState extends Equatable {
  const ConnectState();

  @override
  List<Object> get props => [];
}

class Uninitialised extends ConnectState {}

class Loading extends ConnectState {}

class Connected extends ConnectState {}

class FailedConnection extends ConnectState {
  final String error;

  const FailedConnection(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FailedConnection { '
      'error: $error'
      ' }';
}