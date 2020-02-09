import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_collection/model/app_tab.dart';

import 'tab.dart';


class TabBloc extends Bloc<TabEvent, AppTab> {

  @override
  AppTab get initialState => AppTab.game;

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {

    if(event is UpdateTab) {

      yield event.tab;

    }

  }

}