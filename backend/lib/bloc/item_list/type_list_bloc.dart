import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeView;
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

    final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findAllWithView(PurchaseTypeView.Main);
    return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<PurchaseType>> getReadViewStream(UpdateView event) {

    final PurchaseTypeView view = PurchaseTypeView.values[event.viewIndex];
    final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findAllWithView(view);
    return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);

  }
}