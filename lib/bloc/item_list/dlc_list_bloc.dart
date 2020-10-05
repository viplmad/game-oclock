import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class DLCListBloc extends ItemListBloc<DLC> {

  DLCListBloc({
    @required ICollectionRepository iCollectionRepository,
    @required DLCListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<DLC>> getReadAllStream() {

    return iCollectionRepository.getAllDLCs();

  }

  @override
  Stream<List<DLC>> getReadViewStream(UpdateView event) {

    DLCView dlcView = DLCView.values[event.viewIndex];

    return iCollectionRepository.getDLCsWithView(dlcView);

  }

}