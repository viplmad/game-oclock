import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/bloc/connection/connection.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'route_constants.dart';
import 'common/loading_icon.dart';


class Connectpage extends StatelessWidget {
  const Connectpage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider<ConnectionBloc>(
      create: (BuildContext context) {
        return ConnectionBloc()..add(Connect());
      },
      child: _ConnectpageBody(),
    );

  }
}

class _ConnectpageBody extends StatelessWidget {
  const _ConnectpageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(GameCollectionLocalisations.appTitle),
      ),
      body: BlocListener<ConnectionBloc, ConnectState>(
        listener: (BuildContext context, ConnectState state) {
          if(state is Connected) {
            Navigator.pushReplacementNamed(
              context,
              homeRoute,
            );
          }
          if(state is NonexistentConnection) {
            Navigator.pushReplacementNamed(
              context,
              repositorySettingsRoute,
            );
          }
        },
        child: Center(
          child: BlocBuilder<ConnectionBloc, ConnectState>(
            builder: (BuildContext context, ConnectState state) {

              if(state is Connecting) {

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: LoadingIcon(),
                    ),
                    Text(GameCollectionLocalisations.of(context).connectingString),
                  ],
                );

              }
              if(state is FailedConnection) {

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(GameCollectionLocalisations.of(context).failedConnectionString),
                    RaisedButton(
                      child: Text(GameCollectionLocalisations.of(context).retryString),
                      onPressed: () {
                        BlocProvider.of<ConnectionBloc>(context).add(Reconnect());
                      },
                    ),
                    RaisedButton(
                      child: Text(GameCollectionLocalisations.of(context).changeRepositoryString),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          repositorySettingsRoute,
                        );
                      },
                    ),
                  ],
                );

              }

              return Container();

            },
          ),
        ),
      ),
    );

  }
}