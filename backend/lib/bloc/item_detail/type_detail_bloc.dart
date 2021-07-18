import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class TypeDetailBloc extends ItemDetailBloc<PurchaseType, PurchaseTypeRepository> {
  TypeDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required TypeDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, repository: collectionRepository.purchaseTypeRepository, managerBloc: managerBloc);
}