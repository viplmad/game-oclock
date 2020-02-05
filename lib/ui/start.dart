import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/ui/common/loading_icon.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';

import 'package:game_collection/model/app_tab.dart';

import 'package:game_collection/bloc/connection/connection.dart';
import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/tab/tab.dart';

import 'homepage.dart';

class StartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Game Collection"),
      ),
      body: ConnectPage(),
    );

  }

}

class ConnectPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocListener<ConnectionBloc, ConnectState>(
      listener: (BuildContext context, ConnectState state) {
        if(state is Connected) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<TabBloc>(
                      create: (BuildContext context) {
                        return TabBloc()..add(UpdateTab(AppTab.game));
                      },
                    ),
                    BlocProvider<GameBloc>(
                      create: (BuildContext context) {
                        return GameBloc(
                          collectionRepository: CollectionRepository(),
                        );
                      },
                    ),
                    BlocProvider<DLCBloc>(
                      create: (BuildContext context) {
                        return DLCBloc(
                          collectionRepository: CollectionRepository(),
                        );
                      },
                    ),
                    BlocProvider<PlatformBloc>(
                      create: (BuildContext context) {
                        return PlatformBloc(
                          collectionRepository: CollectionRepository(),
                        );
                      },
                    ),
                    BlocProvider<PurchaseBloc>(
                      create: (BuildContext context) {
                        return PurchaseBloc(
                          collectionRepository: CollectionRepository(),
                        );
                      },
                    ),
                    BlocProvider<StoreBloc>(
                      create: (BuildContext context) {
                        return StoreBloc(
                          collectionRepository: CollectionRepository(),
                        );
                      },
                    ),
                    BlocProvider<SystemBloc>(
                      create: (BuildContext context) {
                        return SystemBloc(
                          collectionRepository: CollectionRepository(),
                        );
                      },
                    ),
                    BlocProvider<TagBloc>(
                      create: (BuildContext context) {
                        return TagBloc(
                          collectionRepository: CollectionRepository(),
                        );
                      },
                    ),
                    BlocProvider<TypeBloc>(
                      create: (BuildContext context) {
                        return TypeBloc(
                          collectionRepository: CollectionRepository(),
                        );
                      },
                    ),
                  ],
                  child: HomePage(),
                );
              },
            ),
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
    );

  }

}