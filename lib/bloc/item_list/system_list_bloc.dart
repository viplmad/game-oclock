import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list.dart';


class SystemListBloc extends ItemListBloc<System> {

  SystemListBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(iCollectionRepository: collectionRepository);

  @override
  Stream<List<System>> getReadAllStream() {

    return iCollectionRepository.getAllSystems();

  }

  @override
  Future<System> createFuture(AddItem event) {

    return iCollectionRepository.insertSystem(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<System> event) {

    return iCollectionRepository.deleteSystem(event.item.ID);

  }

  @override
  Stream<List<System>> getReadViewStream(UpdateView event) {

    SystemView systemView = SystemView.values[event.viewIndex];

    return iCollectionRepository.getSystemsWithView(systemView);

  }

}