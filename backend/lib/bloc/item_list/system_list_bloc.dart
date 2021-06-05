import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class SystemListBloc extends ItemListBloc<System> {
  SystemListBloc({
    required CollectionRepository iCollectionRepository,
    required SystemListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<System>> getReadAllStream() {

    return iCollectionRepository.findAllSystems();

  }

  @override
  Stream<List<System>> getReadViewStream(UpdateView event) {

    final SystemView systemView = SystemView.values[event.viewIndex];

    return iCollectionRepository.findAllSystemsWithView(systemView);

  }
}