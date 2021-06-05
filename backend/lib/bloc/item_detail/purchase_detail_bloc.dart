import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class PurchaseDetailBloc extends ItemDetailBloc<Purchase, PurchaseUpdateProperties> {
  PurchaseDetailBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required PurchaseDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<Purchase?> getReadStream() {

    return iCollectionRepository.findPurchaseById(itemId);

  }
}