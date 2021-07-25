import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID;
import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import 'item_detail_manager.dart';


class TagDetailManagerBloc extends ItemDetailManagerBloc<GameTag, GameTagEntity, GameTagID, GameTagRepository> {
  TagDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(id: GameTagID(itemId), repository: collectionRepository.gameTagRepository);

  @override
  Future<GameTag> updateFuture(UpdateItemField<GameTag> event) {

    final GameTagEntity entity = GameTagMapper.modelToEntity(event.item);
    final GameTagEntity updatedEntity = GameTagMapper.modelToEntity(event.updatedItem);
    final Future<GameTagEntity> entityFuture = repository.update(entity, updatedEntity);
    return GameTagMapper.futureEntityToModel(entityFuture);

  }
}