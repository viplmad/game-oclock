import 'package:equatable/equatable.dart';


abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object> get props => [];
}

class Connect extends ConnectionEvent {}

class Reconnect extends ConnectionEvent {}