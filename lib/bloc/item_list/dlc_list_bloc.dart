import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/dlc.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class DLCListBloc extends ItemListBloc {

  DLCListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<DLC>> getReadStream() {

    return collectionRepository.getAllDLCs();

  }

}