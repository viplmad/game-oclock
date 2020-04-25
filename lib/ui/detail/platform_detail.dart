import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


const Color platformColour = Colors.black87;

class PlatformDetail extends StatelessWidget {

  const PlatformDetail({Key key, @required this.ID}) : super(key: key);

  final int ID;

  @override
  Widget build(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData platformTheme = contextTheme.copyWith(
      primaryColor: platformColour,
      accentColor: Colors.black12,
    );

    return Scaffold(
      body: Theme(
        data: platformTheme,
        child: _PlatformDetailBody(
          itemID: ID,
          itemDetailBloc: BlocProvider.of<PlatformDetailBloc>(context)..add(LoadItem(ID)),
        ),
      ),
    );

  }

}

const List<Color> typeColours = [
  Colors.blueAccent,
  Colors.deepPurpleAccent,
];

class _PlatformDetailBody extends ItemDetailBody {

  _PlatformDetailBody({
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

    Platform platform = (item as Platform);

    return [
      itemTextField(
        fieldName: plat_nameField,
        value: platform.name,
      ),
      itemChipField(
        fieldName: plat_typeField,
        value: platform.type,
        possibleValues: types,
        possibleValuesColours: typeColours,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      itemListManyRelation(
        itemType: Game,
      ),
      itemListManyRelation( //TODO: show as chips
        itemType: System,
      ),
    ];

  }

  @override
  PlatformRelationBloc itemRelationBlocFunction(Type itemType) {

    return PlatformRelationBloc(
      platformID: itemID,
      relationType: itemType,
      itemBloc: itemBloc,
    );

  }

}