import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class TypeListBloc extends ItemListBloc<PurchaseType> {

  TypeListBloc({
    @required ICollectionRepository iCollectionRepository,
    @required TypeListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<PurchaseType>> getReadAllStream() {

    return iCollectionRepository.getAllTypes();

  }

  @override
  Stream<List<PurchaseType>> getReadViewStream(UpdateView event) {

    TypeView typeView = TypeView.values[event.viewIndex];

    return iCollectionRepository.getTypesWithView(typeView);

  }

}