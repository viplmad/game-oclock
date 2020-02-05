import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/store.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class StoreListBloc extends ItemListBloc {

  StoreListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Store>> getReadStream() {

    return collectionRepository.getAllStores();

  }

}