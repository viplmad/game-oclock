import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import 'item_list_manager.dart';


class PurchaseListManagerBloc extends ItemListManagerBloc<Purchase, PurchaseRepository> {
  PurchaseListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseRepository);
}