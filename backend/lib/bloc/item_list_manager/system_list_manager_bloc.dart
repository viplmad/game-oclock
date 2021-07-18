import 'package:backend/model/model.dart' show System;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import 'item_list_manager.dart';


class SystemListManagerBloc extends ItemListManagerBloc<System, SystemRepository> {
  SystemListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.systemRepository);
}