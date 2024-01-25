import 'package:equatable/equatable.dart';

import 'package:logic/model/model.dart' show GameLogErrorCode;

abstract class GameLogAssistantManagerEvent extends Equatable {
  const GameLogAssistantManagerEvent();

  @override
  List<Object> get props => <Object>[];
}

class WarnGameLogAssistantInvalid extends GameLogAssistantManagerEvent {
  const WarnGameLogAssistantInvalid(this.error, this.errorDescription);

  final GameLogErrorCode error;
  final String errorDescription;

  @override
  List<Object> get props => <Object>[error, errorDescription];

  @override
  String toString() => 'WarnGameLogAssistantInvalid { '
      'error: $error, '
      'errorDescription: $errorDescription'
      ' }';
}
