import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../theme/theme.dart';
import '../relation/relation.dart';
import 'item_detail.dart';


class DLCDetail extends ItemDetail<DLC, DLCDetailBloc, DLCDetailManagerBloc> {
  const DLCDetail({
    Key key,
    @required DLC item,
    void Function(DLC item) onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  DLCDetailBloc detailBlocBuilder(DLCDetailManagerBloc managerBloc) {

    return DLCDetailBloc(
      itemID: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
      managerBloc: managerBloc,
    );

  }

  @override
  DLCDetailManagerBloc managerBlocBuilder() {

    return DLCDetailManagerBloc(
      itemID: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    DLCRelationManagerBloc<Game> _gameRelationManagerBloc = DLCRelationManagerBloc<Game>(
      itemID: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    DLCRelationManagerBloc<Purchase> _purchaseRelationManagerBloc = DLCRelationManagerBloc<Purchase>(
      itemID: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    return [
      blocProviderRelationBuilder<Game>(_gameRelationManagerBloc),
      blocProviderRelationBuilder<Purchase>(_purchaseRelationManagerBloc),

      BlocProvider<DLCRelationManagerBloc<Game>>(
        create: (BuildContext context) {
          return _gameRelationManagerBloc;
        },
      ),
      BlocProvider<DLCRelationManagerBloc<Purchase>>(
        create: (BuildContext context) {
          return _purchaseRelationManagerBloc;
        },
      ),
    ];

  }

  @override
  ThemeData themeData(BuildContext context) => DLCTheme.themeData(context);

  @override
  _DLCDetailBody detailBodyBuilder() {

    return _DLCDetailBody(
      onUpdate: onUpdate,
    );

  }

  BlocProvider<DLCRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(DLCRelationManagerBloc<W> managerBloc) {

    return BlocProvider<DLCRelationBloc<W>>(
      create: (BuildContext context) {
        return DLCRelationBloc<W>(
          itemID: item.id,
          iCollectionRepository: ICollectionRepository.iCollectionRepository,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }

}

class _DLCDetailBody extends ItemDetailBody<DLC, DLCDetailBloc, DLCDetailManagerBloc> {
  _DLCDetailBody({
    Key key,
    void Function(DLC item) onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, DLC dlc) {

    return [
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        field: dlc_nameField,
        value: dlc.name,
      ),
      itemYearField(
        context,
        fieldName: GameCollectionLocalisations.of(context).releaseYearFieldString,
        field: dlc_releaseYearField,
        value: dlc.releaseYear,
      ),
      itemDateTimeField(
        context,
        fieldName: GameCollectionLocalisations.of(context).finishDateFieldString,
        field: dlc_finishDateField,
        value: dlc.finishDate,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {

    return [
      DLCGameRelationList(
        relationName: GameCollectionLocalisations.of(context).baseGameFieldString,
        relationTypeName: GameCollectionLocalisations.of(context).gameString,
      ),
      DLCPurchaseRelationList(
        relationName: GameCollectionLocalisations.of(context).purchasesString,
        relationTypeName: GameCollectionLocalisations.of(context).purchaseString,
      ),
    ];

  }

}