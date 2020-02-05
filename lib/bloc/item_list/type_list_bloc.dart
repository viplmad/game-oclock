import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/type.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class TypeListBloc extends ItemListBloc {

  TypeListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<PurchaseType>> getReadStream() {

    return collectionRepository.getAllTypes();

  }

}