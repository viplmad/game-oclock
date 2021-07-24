import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID;
import 'package:backend/model/model.dart' show Tag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import 'item_list_manager.dart';


class TagListManagerBloc extends ItemListManagerBloc<Tag, GameTagEntity, GameTagID, GameTagRepository> {
  TagListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameTagRepository);

  @override
  Future<Tag> createFuture(AddItem<Tag> event) {

    final GameTagEntity entity = GameTagMapper.modelToEntity(event.item);
    final Future<GameTagEntity> entityFuture = repository.create(entity);
    return GameTagMapper.futureEntityToModel(entityFuture);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Tag> event) {

    final GameTagEntity entity = GameTagMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());

  }
}