import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID;
import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameTagRepository;

import 'item_detail.dart';

class GameTagDetailBloc extends ItemDetailBloc<GameTag, GameTagEntity,
    GameTagID, GameTagRepository> {
  GameTagDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required super.managerBloc,
  }) : super(
          id: GameTagID(itemId),
          repository: collectionRepository.gameTagRepository,
        );

  @override
  Future<GameTag> get() {
    final Future<GameTagEntity> entityFuture = repository.findById(id);
    return GameTagMapper.futureEntityToModel(entityFuture);
  }
}
