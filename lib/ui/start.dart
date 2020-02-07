import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/ui/common/loading_icon.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';

import 'package:game_collection/bloc/connection/connection.dart';

import 'bloc_provider_route.dart';


class StartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Game Collection"),
      ),
      body: _StartPageBody(),
    );

  }

}

class _StartPageBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocListener<ConnectionBloc, ConnectState>(
      listener: (BuildContext context, ConnectState state) {
        if(state is Connected) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return EssentialProvider();
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