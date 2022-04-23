import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID;
import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameTagRepository;

import 'item_detail_manager.dart';

class GameTagDetailManagerBloc extends ItemDetailManagerBloc<GameTag,
    GameTagEntity, GameTagID, GameTagRepository> {
  GameTagDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(
          id: GameTagID(itemId),
          repository: collectionRepository.gameTagRepository,
        );

  @override
  Future<GameTag> update(UpdateItemField<GameTag> event) {
    final GameTagEntity entity = GameTagMapper.modelToEntity(event.item);
    final GameTagEntity updatedEntity =
        GameTagMapper.modelToEntity(event.updatedItem);
    final Future<GameTagEntity> entityFuture =
        repository.update(entity, updatedEntity);
    return GameTagMapper.futureEntityToModel(entityFuture);
  }
}
