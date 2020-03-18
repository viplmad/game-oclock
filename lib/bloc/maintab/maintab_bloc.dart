import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_collection/model/app_tab.dart';

import 'maintab.dart';


class MainTabBloc extends Bloc<MainTabEvent, MainTab> {

  @override
  MainTab get initialState => MainTab.game;

  @override
  Stream<MainTab> mapEventToState(MainTabEvent event) async* {

    if(event is UpdateMainTab) {

      yield event.tab;

    }

  }

}