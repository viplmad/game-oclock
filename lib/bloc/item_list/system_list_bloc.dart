import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class SystemListBloc extends ItemListBloc<System> {
  SystemListBloc({
    @required ICollectionRepository iCollectionRepository,
    @required SystemListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<System>> getReadAllStream() {

    return iCollectionRepository.getAllSystems();

  }

  @override
  Stream<List<System>> getReadViewStream(UpdateView event) {

    SystemView systemView = SystemView.values[event.viewIndex];

    return iCollectionRepository.getSystemsWithView(systemView);

  }
}