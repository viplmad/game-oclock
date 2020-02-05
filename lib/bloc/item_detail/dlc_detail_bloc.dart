import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/dlc.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class DLCDetailBloc extends ItemDetailBloc {

  DLCDetailBloc({
    @required ItemBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<DLC> getReadIDStream(int ID) {

    return collectionRepository.getDLCWithID(ID);

  }

}