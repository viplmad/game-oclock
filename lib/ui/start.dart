import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/connection/connection.dart';

import 'route_constants.dart';
import 'common/loading_icon.dart';
import 'common/show_snackbar.dart';


class Startpage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocProvider<ConnectionBloc>(
      create: (BuildContext context) {
        return ConnectionBloc(
          iCollectionRepository: CollectionRepository(),
        )..add(Connect());
      },
      child: _StartpageBody(),
    );

  }

}

class _StartpageBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Game Collection"),
      ),
      body: BlocListener<ConnectionBloc, ConnectState>(
        listener: (BuildContext context, ConnectState state) {
          if(state is Connected) {
            Navigator.pushReplacementNamed(
              context,
              homeRoute,
            );
          }
          if(state is FailedConnection) {
            showSnackBar(
              scaffoldState: Scaffold.of(context),
              message: state.error,
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: LoadingIcon(),
              ),
              Text("Connecting..."),
            ],
          ),
        ),
      ),
    );

  }

}