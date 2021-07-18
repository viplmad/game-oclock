import 'package:backend/model/model.dart' show System;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class SystemDetailBloc extends ItemDetailBloc<System, SystemRepository> {
  SystemDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required SystemDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, repository: collectionRepository.systemRepository, managerBloc: managerBloc);
}