import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class DLCDetailBloc extends ItemDetailBloc<DLC> {

  DLCDetailBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
    @required DLCDetailManagerBloc managerBloc,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<DLC> getReadStream() {

    return iCollectionRepository.getDLCWithID(itemID);

  }

}