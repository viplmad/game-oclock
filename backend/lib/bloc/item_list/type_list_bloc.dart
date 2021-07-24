import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeID, TypeView;
import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/mapper/mapper.dart' show PurchaseTypeMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class TypeListBloc extends ItemListBloc<PurchaseType, PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeRepository> {
  TypeListBloc({
    required GameCollectionRepository collectionRepository,
    required TypeListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.purchaseTypeRepository, managerBloc: managerBloc);

  @override
  Future<List<PurchaseType>> getReadAllStream() {

    final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findAllPurchaseTypesWithView(TypeView.Main);
    return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<PurchaseType>> getReadViewStream(UpdateView event) {

    final TypeView view = TypeView.values[event.viewIndex];
    final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findAllPurchaseTypesWithView(view);
    return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);

  }
}