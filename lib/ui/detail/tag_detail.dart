import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart' show TagDTO, NewTagDTO;

import 'package:logic/model/model.dart' show ItemImage;
import 'package:logic/service/service.dart' show GameCollectionService;
import 'package:logic/bloc/item_detail/item_detail.dart';
import 'package:logic/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import '../relation/relation.dart';
import '../theme/theme.dart' show TagTheme;
import 'item_detail.dart';

class GameTagDetail
    extends ItemDetail<TagDTO, NewTagDTO, TagDetailBloc, TagDetailManagerBloc> {
  const GameTagDetail({
    Key? key,
    required super.item,
    super.onChange,
  }) : super(key: key);

  @override
  TagDetailBloc detailBlocBuilder(
    GameCollectionService collectionService,
    TagDetailManagerBloc managerBloc,
  ) {
    return TagDetailBloc(
      itemId: item.id,
      collectionService: collectionService,
      managerBloc: managerBloc,
    );
  }

  @override
  TagDetailManagerBloc managerBlocBuilder(
    GameCollectionService collectionService,
  ) {
    return TagDetailManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameCollectionService collectionService,
  ) {
    final TagGameRelationManagerBloc gameRelationManagerBloc =
        TagGameRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      BlocProvider<TagGameRelationBloc>(
        create: (BuildContext context) {
          return TagGameRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: gameRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<TagGameRelationManagerBloc>(
        create: (BuildContext context) {
          return gameRelationManagerBloc;
        },
      ),
    ];
  }

  @override
  // ignore: library_private_types_in_public_api
  _GameTagDetailBody detailBodyBuilder() {
    return _GameTagDetailBody(
      itemId: item.id,
      onChange: onChange,
    );
  }
}

// ignore: must_be_immutable
class _GameTagDetailBody extends ItemDetailBody<TagDTO, NewTagDTO,
    TagDetailBloc, TagDetailManagerBloc> {
  _GameTagDetailBody({
    Key? key,
    required this.itemId,
    super.onChange,
  }) : super(
          key: key,
          hasImage: TagTheme.hasImage,
        );

  final String itemId;

  @override
  String itemTitle(TagDTO item) => TagTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, TagDTO tag) {
    return <Widget>[
      itemTextField(
        context,
        fieldName: AppLocalizations.of(context)!.nameFieldString,
        value: tag.name,
        item: tag,
        itemUpdater: (String newValue) => tag.newWith(name: newValue),
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {
    return <Widget>[
      TagGameRelationList(
        relationName: AppLocalizations.of(context)!.gamesString,
        relationTypeName: AppLocalizations.of(context)!.gameString,
      ),
    ];
  }

  @override
  List<Widget> itemSkeletonFieldsBuilder(BuildContext context) {
    int order = 0;

    return <Widget>[
      itemSkeletonField(
        fieldName: AppLocalizations.of(context)!.nameFieldString,
        order: order++,
      ),
    ];
  }

  @override
  ItemImage buildItemImage(TagDTO item) {
    return const ItemImage.empty();
  }

  @override
  void reloadItemRelations(BuildContext context) {
    BlocProvider.of<TagGameRelationBloc>(context).add(ReloadItemRelation());
  }
}
