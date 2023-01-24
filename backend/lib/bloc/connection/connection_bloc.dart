import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show TokenResponse;

import 'package:logic/model/model.dart' show ServerConnection;
import 'package:logic/service/service.dart' show GameCollectionService;
import 'package:logic/preferences/shared_preferences_state.dart';

import 'connection.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectState> {
  ConnectionBloc({required this.collectionService}) : super(Connecting()) {
    on<Connect>(_mapConnectToState);
  }

  final GameCollectionService collectionService;

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
      try {
        final ServerConnection connection =
            (await SharedPreferencesState.retrieveActiveServer())!;

        collectionService.connect(connection);
        final TokenResponse? refreshTokenResponse = await collectionService
            .testAuth(connection.tokenResponse.refreshToken);
        // If token was expired -> refresh token used and returned new token response
        if (refreshTokenResponse != null) {
          collectionService.connect(connection.withToken(refreshTokenResponse));
        }

        emit(
          Connected(),
        );
      } catch (e) {
        emit(
          FailedConnection(e.toString()),
        );
      }
    }
  }
}
