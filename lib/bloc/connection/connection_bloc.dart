import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'connection.dart';


class ConnectionBloc extends Bloc<ConnectionEvent, ConnectState> {

  ConnectionBloc({@required this.iCollectionRepository});

  final ICollectionRepository iCollectionRepository;

  @override
  ConnectState get initialState => Uninitialised();

  @override
  Stream<ConnectState> mapEventToState(ConnectionEvent event) async* {

    if(event is Connect) {

      yield* _mapConnectToState();

    }

  }

  Stream<ConnectState> _mapConnectToState() async* {

    yield Connecting();

    try {

      await iCollectionRepository.open();
      yield Connected();

    } catch(e) {

      yield FailedConnection(e.toString());

    }

  }

}