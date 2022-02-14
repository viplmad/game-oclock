import 'package:backend/entity/entity.dart' show StoreEntity, StoreID;
import 'package:backend/model/model.dart' show Store;
import 'package:backend/mapper/mapper.dart' show StoreMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, StoreRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';

class StoreDetailBloc
    extends ItemDetailBloc<Store, StoreEntity, StoreID, StoreRepository> {
  StoreDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required StoreDetailManagerBloc managerBloc,
  }) : super(
          id: StoreID(itemId),
          repository: collectionRepository.storeRepository,
          managerBloc: managerBloc,
        );

  @override
  Future<Store> getReadFuture() {
    final Future<StoreEntity> entityFuture = repository.findById(id);
    return StoreMapper.futureEntityToModel(
      entityFuture,
      repository.getImageURI,
    );
  }
}
