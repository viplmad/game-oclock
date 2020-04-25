import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'connection.dart';


class ConnectionBloc extends Bloc<ConnectionEvent, ConnectState> {

  ConnectionBloc({@required this.collectionRepository});

  final ICollectionRepository collectionRepository;

  @override
  ConnectState get initialState => Uninitialised();

  @override
  Stream<ConnectState> mapEventToState(ConnectionEvent event) async* {

    if(event is Connect) {

      yield* _mapStartToState();

    } else if(event is Reconnect) {

      yield* _mapReconnectToState();

    }

  }

  Stream<ConnectState> _mapStartToState() async* {

    yield Connecting();

    try {

      await collectionRepository.open();
      yield Connected();

    } catch(e) {

      yield FailedConnection(e.toString());

    }

  }

  Stream<ConnectState> _mapReconnectToState() async* {

    yield Reconnecting();

    try {

      collectionRepository.reconnect();
      await collectionRepository.open();
      yield Connected();

    } catch(e) {

      yield FailedConnection(e.toString());

    }

  }

}