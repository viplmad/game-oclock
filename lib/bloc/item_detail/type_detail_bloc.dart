import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class TypeDetailBloc extends ItemDetailBloc {

  TypeDetailBloc({
    @required ItemBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<PurchaseType> getReadIDStream(LoadItem event) {

    return collectionRepository.getTypeWithID(event.ID);

  }

}