import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class TypeDetailBloc extends ItemDetailBloc<PurchaseType, Object> {
  TypeDetailBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required TypeDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<PurchaseType?> getReadStream() {

    return iCollectionRepository.findPurchaseTypeById(itemId);

  }
}