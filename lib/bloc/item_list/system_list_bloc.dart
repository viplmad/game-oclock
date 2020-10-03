import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_list.dart';


class SystemListBloc extends ItemListBloc<System> {

  SystemListBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<System>> getReadAllStream() {

    return collectionRepository.getAllSystems();

  }

  @override
  Future<System> createFuture(AddItem event) {

    return collectionRepository.insertSystem(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<System> event) {

    return collectionRepository.deleteSystem(event.item.ID);

  }

  @override
  Stream<List<System>> getReadViewStream(UpdateView event) {

    SystemView systemView = SystemView.values[event.viewIndex];

    return collectionRepository.getSystemsWithView(systemView);

  }

}