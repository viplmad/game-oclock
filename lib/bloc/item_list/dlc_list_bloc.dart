import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list.dart';


class DLCListBloc extends ItemListBloc<DLC> {

  DLCListBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<DLC>> getReadAllStream() {

    return iCollectionRepository.getAllDLCs();

  }

  @override
  Future<DLC> createFuture(AddItem event) {

    return iCollectionRepository.insertDLC(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<DLC> event) {

    return iCollectionRepository.deleteDLC(event.item.ID);

  }

  @override
  Stream<List<DLC>> getReadViewStream(UpdateView event) {

    DLCView dlcView = DLCView.values[event.viewIndex];

    return iCollectionRepository.getDLCsWithView(dlcView);

  }

}