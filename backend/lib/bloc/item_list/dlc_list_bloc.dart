import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class DLCListBloc extends ItemListBloc<DLC> {
  DLCListBloc({
    required CollectionRepository iCollectionRepository,
    required DLCListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<DLC>> getReadAllStream() {

    return iCollectionRepository.findAllDLCs();

  }

  @override
  Stream<List<DLC>> getReadViewStream(UpdateView event) {

    final DLCView dlcView = DLCView.values[event.viewIndex];

    return iCollectionRepository.findAllDLCsWithView(dlcView);

  }
}