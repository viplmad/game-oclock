import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:backend/connector/connector.dart' show ItemConnector, ImageConnector;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;
import 'package:backend/preferences/repository_preferences.dart';

import 'connection.dart';


class ConnectionBloc extends Bloc<ConnectionEvent, ConnectState> {
  ConnectionBloc({
    required this.collectionRepository
  }) : super(Connecting());

  final GameCollectionRepository collectionRepository;

  @override
  Stream<ConnectState> mapEventToState(ConnectionEvent event) async* {

    if(event is Connect) {

      yield* _mapConnectToState();

    } else if(event is Reconnect) {

      yield* _mapReconnectToState();

    }

  }

  Stream<ConnectState> _mapConnectToState() async* {

    yield Connecting();

    final bool existsConnection = await RepositoryPreferences.existsRepository();
    if(!existsConnection) {

      yield NonexistentConnection();

    } else {

      try {

        final ItemConnector itemConnector = await RepositoryPreferences.retrieveItemConnector();
        final ImageConnector imageConnector = await RepositoryPreferences.retrieveImageConnector();

        collectionRepository.connect(itemConnector, imageConnector);
        await collectionRepository.open();

        yield Connected();

      } catch(e) {

        yield FailedConnection(e.toString());

      }

    }

  }

  Stream<ConnectState> _mapReconnectToState() async* {

    yield Connecting();

    try {

      collectionRepository.reconnect();
      await collectionRepository.open();
      yield Connected();

    } catch(e) {

      yield FailedConnection(e.toString());

    }

  }
}