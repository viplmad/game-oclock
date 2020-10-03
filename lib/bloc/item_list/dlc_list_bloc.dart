import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_list.dart';


class DLCListBloc extends ItemListBloc<DLC> {

  DLCListBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<DLC>> getReadAllStream() {

    return collectionRepository.getAllDLCs();

  }

  @override
  Future<DLC> createFuture(AddItem event) {

    return collectionRepository.insertDLC(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<DLC> event) {

    return collectionRepository.deleteDLC(event.item.ID);

  }

  @override
  Stream<List<DLC>> getReadViewStream(UpdateView event) {

    DLCView dlcView = DLCView.values[event.viewIndex];

    return collectionRepository.getDLCsWithView(dlcView);

  }

}