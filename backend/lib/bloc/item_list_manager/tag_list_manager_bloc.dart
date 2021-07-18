import 'package:backend/model/model.dart' show Tag;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import 'item_list_manager.dart';


class TagListManagerBloc extends ItemListManagerBloc<Tag, GameTagRepository> {
  TagListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.gameTagRepository);
}