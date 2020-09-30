import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class TypeListBloc extends ItemListBloc<PurchaseType> {

  TypeListBloc({
    @required TypeBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<PurchaseType>> getReadAllStream() {

    return collectionRepository.getAllTypes();

  }

  @override
  Stream<List<PurchaseType>> getReadViewStream(UpdateView event) {

    int viewIndex = typeViews.indexOf(event.view);
    TypeView typeView = TypeView.values[viewIndex];

    return collectionRepository.getTypesWithView(typeView);

  }

}