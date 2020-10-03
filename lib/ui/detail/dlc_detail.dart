import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import '../theme/theme.dart';
import '../relation/relation.dart';
import 'item_detail.dart';


class DLCDetail extends ItemDetail<DLC, DLCDetailBloc> {
  const DLCDetail({Key key, @required DLC item}) : super(item: item, key: key);

  @override
  DLCDetailBloc detailBlocBuilder() {

    return DLCDetailBloc(
      dlcID: item.ID,
      iCollectionRepository: CollectionRepository(),
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    return [
      blocProviderRelationBuilder<Game>(),
      blocProviderRelationBuilder<Purchase>(),
    ];

  }

  @override
  ThemeData getThemeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData dlcTheme = contextTheme.copyWith(
      primaryColor: dlcColour,
      accentColor: dlcAccentColour,
    );

    return dlcTheme;

  }

  @override
  _DLCDetailBody detailBodyBuilder() {

    return _DLCDetailBody();

  }

  BlocProvider<DLCRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>() {

    return BlocProvider<DLCRelationBloc<W>>(
      create: (BuildContext context) {
        return DLCRelationBloc<W>(
          dlcID: item.ID,
          iCollectionRepository: CollectionRepository(),
        )..add(LoadItemRelation());
      },
    );

  }

}

class _DLCDetailBody extends ItemDetailBody<DLC, DLCDetailBloc> {

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, DLC dlc) {

    return [
      itemTextField(
        context,
        fieldName: dlc_nameField,
        value: dlc.name,
      ),
      itemYearField(
        context,
        fieldName: dlc_releaseYearField,
        value: dlc.releaseYear,
      ),
      itemDateTimeField(
        context,
        fieldName: dlc_finishDateField,
        value: dlc.finishDate,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      DLCGameRelationList(
        shownName: dlc_baseGameField,
      ),
      DLCPurchaseRelationList(),
    ];

  }

}