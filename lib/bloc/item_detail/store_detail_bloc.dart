import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class StoreDetailBloc extends ItemDetailBloc<Store> {
  StoreDetailBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required StoreDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<Store?> getReadStream() {

    return iCollectionRepository.getStoreWithId(itemId);

  }
}