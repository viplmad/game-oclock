import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class SystemDetailBloc extends ItemDetailBloc<System, Object> {
  SystemDetailBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
    required SystemDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<System?> getReadStream() {

    return iCollectionRepository.findSystemById(itemId);

  }
}