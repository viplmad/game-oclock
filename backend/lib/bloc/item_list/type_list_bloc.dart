import 'package:backend/model/model.dart' show PurchaseType, TypeView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class TypeListBloc extends ItemListBloc<PurchaseType, PurchaseTypeRepository> {
  TypeListBloc({
    required GameCollectionRepository collectionRepository,
    required TypeListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.purchaseTypeRepository, managerBloc: managerBloc);

  @override
  Stream<List<PurchaseType>> getReadViewStream(UpdateView event) {

    final TypeView typeView = TypeView.values[event.viewIndex];

    return repository.findAllPurchaseTypesWithView(typeView);

  }
}