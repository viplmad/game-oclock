import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class PurchaseDetailBloc extends ItemDetailBloc<Purchase, PurchaseRepository> {
  PurchaseDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required PurchaseDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, repository: collectionRepository.purchaseRepository, managerBloc: managerBloc);
}