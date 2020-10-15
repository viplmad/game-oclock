import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class DLCDetailBloc extends ItemDetailBloc<DLC> {

  DLCDetailBloc({
    @required int itemId,
    @required ICollectionRepository iCollectionRepository,
    @required DLCDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<DLC> getReadStream() {

    return iCollectionRepository.getDLCWithId(itemId);

  }

}