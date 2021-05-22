import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class TypeListBloc extends ItemListBloc<PurchaseType> {
  TypeListBloc({
    required ICollectionRepository iCollectionRepository,
    required TypeListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<PurchaseType>> getReadAllStream() {

    return iCollectionRepository.findAllPurchaseTypes();

  }

  @override
  Stream<List<PurchaseType>> getReadViewStream(UpdateView event) {

    final TypeView typeView = TypeView.values[event.viewIndex];

    return iCollectionRepository.findAllPurchaseTypesWithView(typeView);

  }
}