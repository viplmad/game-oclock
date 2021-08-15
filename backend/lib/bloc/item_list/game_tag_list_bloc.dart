import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID, GameTagView;
import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class GameTagListBloc extends ItemListBloc<GameTag, GameTagEntity, GameTagID, GameTagRepository> {
  GameTagListBloc({
    required GameCollectionRepository collectionRepository,
    required GameTagListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.gameTagRepository, managerBloc: managerBloc);

  @override
  Future<List<GameTag>> getReadAllStream() {

    final Future<List<GameTagEntity>> entityListFuture = repository.findAllWithView(GameTagView.Main);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<GameTag>> getReadViewStream(UpdateView event) {

    final GameTagView view = GameTagView.values[event.viewIndex];
    final Future<List<GameTagEntity>> entityListFuture = repository.findAllWithView(view);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);

  }
}