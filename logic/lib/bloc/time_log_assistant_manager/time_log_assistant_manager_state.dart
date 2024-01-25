import 'package:equatable/equatable.dart';

import 'package:logic/model/model.dart' show GameLogErrorCode;

abstract class GameLogAssistantManagerState extends Equatable {
  const GameLogAssistantManagerState();

  @override
  List<Object> get props => <Object>[];
}

class GameLogAssistantManagerInitialised extends GameLogAssistantManagerState {}

class GameLogAssistantInvalid extends GameLogAssistantManagerState {
  const GameLogAssistantInvalid(this.error, this.errorDescription);

  final GameLogErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'GameLogAssistantInvalid { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
