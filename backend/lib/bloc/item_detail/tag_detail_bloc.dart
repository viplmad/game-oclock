import 'package:backend/model/model.dart' show Tag;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameTagRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class TagDetailBloc extends ItemDetailBloc<Tag, GameTagRepository> {
  TagDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required TagDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, repository: collectionRepository.gameTagRepository, managerBloc: managerBloc);
}