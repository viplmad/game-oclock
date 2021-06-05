import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class DLCDetailBloc extends ItemDetailBloc<DLC, DLCUpdateProperties> {
  DLCDetailBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required DLCDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<DLC?> getReadStream() {

    return iCollectionRepository.findDLCById(itemId);

  }
}