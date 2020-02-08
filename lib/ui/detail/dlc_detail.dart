import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';
import 'package:game_collection/ui/common/loading_icon.dart';

import 'item_detail.dart';


class DLCDetail extends StatelessWidget {

  const DLCDetail({Key key, @required this.ID, @required this.itemDetailBloc}) : super(key: key);

  final int ID;
  final ItemDetailBloc itemDetailBloc;

  ItemBloc get itemBloc => itemDetailBloc.itemBloc;

  @override
  Widget build(BuildContext context) {

    itemDetailBloc.add(LoadItem(ID));

    return MultiBlocProvider(
      providers: [
        BlocProvider<DLCRelationBloc>(
          create: (BuildContext context) {
            return DLCRelationBloc(
              dlcID: ID,
              relationField: gameTable,
              itemBloc: itemBloc,
            )..add(LoadItemRelation());
          },
        ),
        BlocProvider<DLCRelationBloc>(
          create: (BuildContext context) {
            return DLCRelationBloc(
              dlcID: ID,
              relationField: purchaseTable,
              itemBloc: itemBloc,
            )..add(LoadItemRelation());
          },
        ),
      ],
      child: Scaffold(
        body: _DLCDetailBody(
          itemID: ID,
          itemDetailBloc: itemDetailBloc,
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
  List<Widget> itemDetailFields(BuildContext context) {

    DLC dlc = (item as DLC);

    return [
      ItemTextField(
        fieldName: dlc_nameField,
        value: dlc.name,
        update: (String newName) {
          itemBloc.add(
            UpdateItemField(
              dlc,
              dlc_nameField,
              newName,
            ),
          );
        },
      ),
      ItemYearField(
        fieldName: dlc_releaseYearField,
        value: dlc.releaseYear,
        update: (int newYear) {
          itemBloc.add(
            UpdateItemField(
              dlc,
              dlc_releaseYearField,
              newYear,
            ),
          );
        },
      ),
      ItemDateTimeField(
        fieldName: dlc_finishDateField,
        value: dlc.finishDate,
        update: (DateTime newDate) {
          itemBloc.add(
            UpdateItemField(
              dlc,
              dlc_finishDateField,
              newDate,
            ),
          );
        },
      ),
      BlocBuilder<ItemRelationBloc, ItemRelationState>(
        bloc: BlocProvider.of<DLCRelationBloc>(context),
        builder: (BuildContext context, ItemRelationState state) {

          if(state is ItemRelationLoaded) {
            return ResultsListSingle(
              items: state.items,
              tableName: gameTable,
              updateDelete: (CollectionItem deletedItem) {
                itemBloc.add(DeleteItemRelation(
                  item,
                  gameTable,
                  deletedItem,
                ));
              },
            );
          }

          return LoadingIcon();

        },
      ),
    ];

  }

}