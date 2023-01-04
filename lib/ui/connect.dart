import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/bloc/connection/connection.dart';
import 'package:backend/service/service.dart' show GameCollectionService;

import 'package:game_collection/localisations/localisations.dart';

import 'route_constants.dart';
import 'theme/app_theme.dart';

class Connectpage extends StatelessWidget {
  const Connectpage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectionBloc>(
      create: (BuildContext context) {
        return ConnectionBloc(
          collectionService:
              RepositoryProvider.of<GameCollectionService>(context),
        )..add(Connect());
      },
      child: const _ConnectpageBody(),
    );
  }
}

class _ConnectpageBody extends StatelessWidget {
  const _ConnectpageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(GameCollectionLocalisations.appTitle),
        // No elevation so background color is not affected by theme
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: BlocListener<ConnectionBloc, ConnectState>(
        listener: (BuildContext context, ConnectState state) async {
          if (state is Connected) {
            Navigator.pushReplacementNamed(
              context,
              homeRoute,
            );
          }
          if (state is NonexistentConnection) {
            Navigator.pushReplacementNamed(
              context,
              serverSettingsRoute,
            );
          }
        },
        child: Center(
          child: BlocBuilder<ConnectionBloc, ConnectState>(
            builder: (BuildContext context, ConnectState state) {
              if (state is Connecting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      GameCollectionLocalisations.of(context).connectingString,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Center(
                        child: LinearProgressIndicator(),
                      ),
                    ),
                  ],
                );
              }
              if (state is FailedConnection) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Text(
                          GameCollectionLocalisations.of(context)
                              .failedConnectionString,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<ConnectionBloc>(context)
                              .add(Connect());
                        },
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor:
                              AppTheme.defaultThemeSurfaceTintColor(context),
                        ),
                        child: Text(
                          GameCollectionLocalisations.of(context).retryString,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pushReplacementNamed(
                            context,
                            serverSettingsRoute,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor:
                              AppTheme.defaultThemeSurfaceTintColor(context),
                        ),
                        child: Text(
                          GameCollectionLocalisations.of(context)
                              .changeRepositoryString,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
