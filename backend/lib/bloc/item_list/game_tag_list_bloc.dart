import 'package:backend/entity/entity.dart'
    show GameTagEntity, GameTagID, GameTagView;
import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameTagRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';

class GameTagListBloc
    extends ItemListBloc<GameTag, GameTagEntity, GameTagID, GameTagRepository> {
  GameTagListBloc({
    required GameCollectionRepository collectionRepository,
    required GameTagListManagerBloc managerBloc,
  }) : super(
          repository: collectionRepository.gameTagRepository,
          managerBloc: managerBloc,
        );

  @override
  Future<List<GameTag>> getReadAllStream([int? page]) {
    final Future<List<GameTagEntity>> entityListFuture =
        repository.findAllWithView(GameTagView.main, page);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);
  }

  @override
  Future<List<GameTag>> getReadViewStream(int viewIndex, [int? page]) {
    final GameTagView view = GameTagView.values[viewIndex];
    final Future<List<GameTagEntity>> entityListFuture =
        repository.findAllWithView(view, page);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);
  }
}
