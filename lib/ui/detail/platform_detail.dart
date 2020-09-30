import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'item_detail.dart';


const Color platformColour = Colors.black87;

class PlatformDetail extends StatelessWidget {

  const PlatformDetail({Key key, @required this.platform}) : super(key: key);

  final Platform platform;

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
          item: platform,
          itemDetailBloc: BlocProvider.of<PlatformDetailBloc>(context)..add(LoadItem(platform.ID)),
        ),
      ),
    );

  }

}

const List<Color> typeColours = [
  Colors.blueAccent,
  Colors.deepPurpleAccent,
];

class _PlatformDetailBody extends ItemDetailBody<Platform> {

  _PlatformDetailBody({
    Key key,
    @required Platform item,
    @required PlatformDetailBloc itemDetailBloc,
  }) : super(
    key: key,
    item: item,
    itemDetailBloc: itemDetailBloc,
  );

  @override
  List<Widget> itemFieldsBuilder(Platform platform) {

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
      itemListManyRelation<Game>(),
      itemListManyRelation<System>() //TODO: show as chips
    ];

  }

  @override
  PlatformRelationBloc<W> itemRelationBlocFunction<W extends CollectionItem>() {

    return PlatformRelationBloc<W>(
      platformID: item.ID,
      itemBloc: itemBloc,
    );

  }

}