import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


const Color dlcColour = Colors.deepPurple;

class DLCDetail extends StatelessWidget {

  const DLCDetail({Key key, @required this.ID}) : super(key: key);

  final int ID;

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
          itemID: ID,
          itemDetailBloc: BlocProvider.of<DLCDetailBloc>(context)..add(LoadItem(ID)),
        ),
      ),
    );

  }

}

class _DLCDetailBody extends ItemDetailBody {

  _DLCDetailBody({
    Key key,
    @required int itemID,
    @required ItemDetailBloc itemDetailBloc,
  }) : super(
    key: key,
    itemID: itemID,
    itemDetailBloc: itemDetailBloc,
  );

  @override
  List<Widget> itemFieldsBuilder(CollectionItem item) {

    DLC dlc = (item as DLC);

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
      itemListSingleRelation(
        itemType: Game,
        shownName: dlc_baseGameField,
      ),
      itemListManyRelation(
        itemType: Purchase,
      ),
    ];

  }

  @override
  DLCRelationBloc itemRelationBlocFunction(Type itemType) {

    return DLCRelationBloc(
      dlcID: itemID,
      relationType: itemType,
      itemBloc: itemBloc,
    );

  }

}