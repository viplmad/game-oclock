import 'package:backend/entity/entity.dart' show StoreEntity, StoreID;
import 'package:backend/model/model.dart' show Store;
import 'package:backend/mapper/mapper.dart' show StoreMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, StoreRepository;

import 'item_detail.dart';

class StoreDetailBloc
    extends ItemDetailBloc<Store, StoreEntity, StoreID, StoreRepository> {
  StoreDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required super.managerBloc,
  }) : super(
          id: StoreID(itemId),
          repository: collectionRepository.storeRepository,
        );

  @override
  Future<Store> get() {
    final Future<StoreEntity> entityFuture = repository.findById(id);
    return StoreMapper.futureEntityToModel(
      entityFuture,
      repository.getImageURI,
    );
  }
}
