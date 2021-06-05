import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class StoreDetailBloc extends ItemDetailBloc<Store, StoreUpdateProperties> {
  StoreDetailBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required StoreDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<Store?> getReadStream() {

    return iCollectionRepository.findStoreById(itemId);

  }
}