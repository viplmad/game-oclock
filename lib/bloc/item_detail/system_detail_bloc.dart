import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class SystemDetailBloc extends ItemDetailBloc<System> {

  SystemDetailBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
    @required SystemDetailManagerBloc managerBloc,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<System> getReadStream() {

    return iCollectionRepository.getSystemWithID(itemID);

  }

}