import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID;
import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class TagDetailBloc extends ItemDetailBloc<GameTag, GameTagEntity, GameTagID, GameTagRepository> {
  TagDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required TagDetailManagerBloc managerBloc,
  }) : super(id: GameTagID(itemId), repository: collectionRepository.gameTagRepository, managerBloc: managerBloc);

  @override
  Future<GameTag> getReadFuture() {

    final Future<GameTagEntity> entityFuture = repository.findById(id);
    return GameTagMapper.futureEntityToModel(entityFuture);

  }
}