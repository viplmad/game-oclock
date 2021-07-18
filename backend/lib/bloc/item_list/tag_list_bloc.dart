import 'package:backend/model/model.dart' show Tag, TagView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class TagListBloc extends ItemListBloc<Tag, GameTagRepository> {
  TagListBloc({
    required GameCollectionRepository collectionRepository,
    required TagListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.gameTagRepository, managerBloc: managerBloc);

  @override
  Stream<List<Tag>> getReadViewStream(UpdateView event) {

    final TagView tagView = TagView.values[event.viewIndex];

    return repository.findAllGameTagsWithView(tagView);

  }
}