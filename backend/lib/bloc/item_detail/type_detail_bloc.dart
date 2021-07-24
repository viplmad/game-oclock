import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeID;
import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/mapper/mapper.dart' show PurchaseTypeMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class TypeDetailBloc extends ItemDetailBloc<PurchaseType, PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeRepository> {
  TypeDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required TypeDetailManagerBloc managerBloc,
  }) : super(id: PurchaseTypeID(itemId), repository: collectionRepository.purchaseTypeRepository, managerBloc: managerBloc);

  @override
  Future<PurchaseType> getReadFuture() {

    final Future<PurchaseTypeEntity> entityFuture = repository.findById(id);
    return PurchaseTypeMapper.futureEntityToModel(entityFuture);

  }
}