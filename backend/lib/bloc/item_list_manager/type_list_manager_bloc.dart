import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import 'item_list_manager.dart';


class TypeListManagerBloc extends ItemListManagerBloc<PurchaseType, PurchaseTypeRepository> {
  TypeListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseTypeRepository);
}