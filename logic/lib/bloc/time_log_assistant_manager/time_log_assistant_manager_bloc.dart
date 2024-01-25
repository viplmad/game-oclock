import 'package:bloc/bloc.dart';

import 'time_log_assistant_manager.dart';

class GameLogAssistantManagerBloc
    extends Bloc<GameLogAssistantManagerEvent, GameLogAssistantManagerState> {
  GameLogAssistantManagerBloc() : super(GameLogAssistantManagerInitialised()) {
    on<WarnGameLogAssistantInvalid>(_mapWarnInvalidToState);
  }

  void _mapWarnInvalidToState(
    WarnGameLogAssistantInvalid event,
    Emitter<GameLogAssistantManagerState> emit,
  ) {
    emit(GameLogAssistantInvalid(event.error, event.errorDescription));

    emit(
      GameLogAssistantManagerInitialised(),
    );
  }
}
