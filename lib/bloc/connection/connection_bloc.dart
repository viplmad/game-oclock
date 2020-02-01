import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'connection_event.dart';
import 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectState> {

  final ICollectionRepository collectionRepository;

  ConnectionBloc({@required this.collectionRepository});

  @override
  ConnectState get initialState => Uninitialised();

  @override
  Stream<ConnectState> mapEventToState(ConnectionEvent event) async* {

    if(event is AppStarted) {

      yield* _mapStartToState();

    }

  }

  Stream<ConnectState> _mapStartToState() async* {

    yield Loading();

    try {

      await collectionRepository.open();
      yield Connected();

    } catch(e) {

      yield FailedConnection(e.toString());

    }

  }

}