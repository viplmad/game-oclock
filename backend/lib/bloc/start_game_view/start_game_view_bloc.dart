import 'package:bloc/bloc.dart';

import 'package:backend/preferences/repository_preferences.dart';

import 'start_game_view.dart';

class StartGameViewBloc extends Bloc<StartGameViewEvent, int?> {
  StartGameViewBloc() : super(null) {
    on<LoadStartGameView>(_mapStartToState);
    on<UpdateStartGameView>(_mapUpdateToState);
  }

  void _mapStartToState(LoadStartGameView event, Emitter<int?> emit) async {
    emit(
      null,
    );

    try {
      final int? startViewIndex =
          await RepositoryPreferences.retrieveInitialGameViewIndex();

      emit(
        startViewIndex,
      );
    } catch (e) {
      emit(
        null,
      );
    }
  }

  void _mapUpdateToState(UpdateStartGameView event, Emitter<int?> emit) async {
    try {
      final int startViewIndex = event.startViewIndex;
      final bool setSuccess =
          await RepositoryPreferences.setStartGameViewIndex(startViewIndex);

      if (setSuccess) {
        emit(
          startViewIndex,
        );
      }
    } catch (e) {
      emit(
        null,
      );
    }
  }
}
