import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID;
import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import 'item_list_manager.dart';


class GameTagListManagerBloc extends ItemListManagerBloc<GameTag, GameTagEntity, GameTagID, GameTagRepository> {
  GameTagListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameTagRepository);

  @override
  Future<GameTag> createFuture(AddItem<GameTag> event) {

    final GameTagEntity entity = GameTagMapper.modelToEntity(event.item);
    final Future<GameTagEntity> entityFuture = repository.create(entity);
    return GameTagMapper.futureEntityToModel(entityFuture);

  }

  @override
  Future<Object?> deleteFuture(DeleteItem<GameTag> event) {

    final GameTagEntity entity = GameTagMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());

  }
}