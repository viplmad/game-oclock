import 'package:bloc/bloc.dart';
import 'package:game_oclock_client/api.dart';

import 'package:logic/model/model.dart' show ServerConnection;
import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/preferences/shared_preferences_state.dart';

import 'connection.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectState> {
  ConnectionBloc({required this.collectionService}) : super(Connecting()) {
    on<Connect>(_mapConnectToState);
  }

  final GameOClockService collectionService;

  void _mapConnectToState(Connect event, Emitter<ConnectState> emit) async {
    emit(
      Connecting(),
    );

    final bool existsConnection =
        await SharedPreferencesState.existsActiveServer();
    if (!existsConnection) {
      emit(
        NonexistentConnection(),
      );
    } else {
      final ServerConnection connection =
          (await SharedPreferencesState.retrieveActiveServer())!;

      collectionService.init(
        connection.host,
        connection.tokenResponse,
        onTokenRefresh: (TokenResponse tokenResponse) async {
          final ServerConnection connection =
              (await SharedPreferencesState.retrieveActiveServer())!;

          final ServerConnection newConnection =
              connection.withToken(tokenResponse);

          // Save connection with new token
          await SharedPreferencesState.setActiveServer(newConnection);
        },
      );

      emit(
        Connected(),
      );
    }
  }
}
