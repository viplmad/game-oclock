import 'package:bloc/bloc.dart';

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;
import 'package:backend/preferences/repository_preferences.dart';

import 'connection.dart';


class ConnectionBloc extends Bloc<ConnectionEvent, ConnectState> {
  ConnectionBloc({
    required this.collectionRepository
  }) : super(Connecting()) {

    on<Connect>(_mapConnectToState);
    on<Reconnect>(_mapReconnectToState);

  }

  final GameCollectionRepository collectionRepository;

  void _mapConnectToState(Connect event, Emitter<ConnectState> emit) async {

    emit(
      Connecting(),
    );

    final bool existsConnection = await RepositoryPreferences.existsItemConnection();
    if(!existsConnection) {

      emit(
        NonexistentConnection(),
      );

    } else {

      try {

        final ItemConnector itemConnector = (await RepositoryPreferences.retrieveActiveItemConnector())!;
        final ImageConnector? imageConnector = await RepositoryPreferences.retrieveActiveImageConnector();

        collectionRepository.connect(itemConnector, imageConnector);
        await collectionRepository.open();

        emit(
          Connected(),
        );

      } catch(e) {

        emit(
          FailedConnection(e.toString()),
        );

      }

    }

  }

  void _mapReconnectToState(Reconnect event, Emitter<ConnectState> emit) async {

    emit(
      Connecting(),
    );

    try {

      collectionRepository.reconnect();
      await collectionRepository.open();

      emit(
        Connected(),
      );

    } catch(e) {

      emit(
        FailedConnection(e.toString()),
      );

    }

  }
}