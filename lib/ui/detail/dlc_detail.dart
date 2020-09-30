import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


const Color dlcColour = Colors.deepPurple;

class DLCDetail extends StatelessWidget {

  const DLCDetail({Key key, @required this.dlc}) : super(key: key);

  final DLC dlc;

  @override
  Widget build(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData dlcTheme = contextTheme.copyWith(
      primaryColor: dlcColour,
      accentColor: Colors.deepPurpleAccent,
    );

    return Scaffold(
      body: Theme(
        data: dlcTheme,
        child: _DLCDetailBody(
          item: dlc,
          itemDetailBloc: BlocProvider.of<DLCDetailBloc>(context)..add(LoadItem(dlc.ID)),
        ),
      ),
    );

  }

}

class _DLCDetailBody extends ItemDetailBody<DLC> {

  _DLCDetailBody({
    Key key,
    @required DLC item,
    @required DLCDetailBloc itemDetailBloc,
  }) : super(
    key: key,
    item: item,
    itemDetailBloc: itemDetailBloc,
  );

  @override
  List<Widget> itemFieldsBuilder(DLC dlc) {

    return [
      itemTextField(
        fieldName: dlc_nameField,
        value: dlc.name,
      ),
      itemYearField(
        fieldName: dlc_releaseYearField,
        value: dlc.releaseYear,
      ),
      itemDateTimeField(
        fieldName: dlc_finishDateField,
        value: dlc.finishDate,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      itemListSingleRelation<Game>(
        shownName: dlc_baseGameField,
      ),
      itemListManyRelation<Purchase>(),
    ];

  }

  @override
  DLCRelationBloc<W> itemRelationBlocFunction<W extends CollectionItem>() {

    return DLCRelationBloc<W>(
      dlcID: item.ID,
      itemBloc: itemBloc,
    );

  }

}