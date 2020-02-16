import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class SystemListBloc extends ItemListBloc {

  SystemListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<System>> getReadAllStream() {

    return collectionRepository.getAllSystems();

  }

  @override
  Stream<List<System>> getReadViewStream(UpdateView event) {

    int viewIndex = systemViews.indexOf(event.view);
    SystemView systemView = SystemView.values[viewIndex];

    return collectionRepository.getSystemsWithView(systemView);

  }

}