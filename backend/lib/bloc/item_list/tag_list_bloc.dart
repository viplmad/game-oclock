import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagID, TagView;
import 'package:backend/model/model.dart' show Tag;
import 'package:backend/mapper/mapper.dart' show GameTagMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class TagListBloc extends ItemListBloc<Tag, GameTagEntity, GameTagID, GameTagRepository> {
  TagListBloc({
    required GameCollectionRepository collectionRepository,
    required TagListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.gameTagRepository, managerBloc: managerBloc);

  @override
  Future<List<Tag>> getReadAllStream() {

    final Future<List<GameTagEntity>> entityListFuture = repository.findAllGameTagsWithView(TagView.Main);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<Tag>> getReadViewStream(UpdateView event) {

    final TagView view = TagView.values[event.viewIndex];
    final Future<List<GameTagEntity>> entityListFuture = repository.findAllGameTagsWithView(view);
    return GameTagMapper.futureEntityListToModelList(entityListFuture);

  }
}