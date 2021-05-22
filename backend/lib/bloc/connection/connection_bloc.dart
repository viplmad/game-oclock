import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:backend/repository/icollection_repository.dart';
import 'package:backend/preferences/repository_preferences.dart';

import 'connection.dart';


class ConnectionBloc extends Bloc<ConnectionEvent, ConnectState> {
  ConnectionBloc() : super(Connecting());

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

        final ICollectionRepository iCollectionRepository = await RepositoryPreferences.retrieveRepository();
        ICollectionRepository.iCollectionRepository = iCollectionRepository;
        await iCollectionRepository.open();
        yield Connected();

      } catch(e) {

        yield FailedConnection(e.toString());

      }

    }

  }

  Stream<ConnectState> _mapReconnectToState() async* {

    yield Connecting();

    try {

      ICollectionRepository.iCollectionRepository!.reconnect();
      await ICollectionRepository.iCollectionRepository!.open();
      yield Connected();

    } catch(e) {

      yield FailedConnection(e.toString());

    }

  }
}