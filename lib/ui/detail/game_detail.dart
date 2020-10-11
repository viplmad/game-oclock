import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import '../theme/theme.dart';
import '../relation/relation.dart';
import 'item_detail.dart';


class GameDetail extends ItemDetail<Game, GameDetailBloc, GameDetailManagerBloc> {
  const GameDetail({
    Key key,
    @required Game item,
    void Function(Game item) onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  GameDetailBloc detailBlocBuilder(GameDetailManagerBloc managerBloc) {

    return GameDetailBloc(
      itemID: item.ID,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
      managerBloc: managerBloc,
    );

  }

  @override
  GameDetailManagerBloc managerBlocBuilder() {

    return GameDetailManagerBloc(
      itemID: item.ID,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    GameRelationManagerBloc<Platform> _platformRelationManagerBloc = GameRelationManagerBloc<Platform>(
      itemID: item.ID,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    GameRelationManagerBloc<Purchase> _purchaseRelationManagerBloc = GameRelationManagerBloc<Purchase>(
      itemID: item.ID,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    GameRelationManagerBloc<DLC> _dlcRelationManagerBloc = GameRelationManagerBloc<DLC>(
      itemID: item.ID,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    GameRelationManagerBloc<Tag> _tagRelationManagerBloc = GameRelationManagerBloc<Tag>(
      itemID: item.ID,
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

    return [
      blocProviderRelationBuilder<Platform>(_platformRelationManagerBloc),
      blocProviderRelationBuilder<Purchase>(_purchaseRelationManagerBloc),
      blocProviderRelationBuilder<DLC>(_dlcRelationManagerBloc),
      blocProviderRelationBuilder<Tag>(_tagRelationManagerBloc),

      BlocProvider<GameRelationManagerBloc<Platform>>(
        create: (BuildContext context) {
          return _platformRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<Purchase>>(
        create: (BuildContext context) {
          return _purchaseRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<DLC>>(
        create: (BuildContext context) {
          return _dlcRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<Tag>>(
        create: (BuildContext context) {
          return _tagRelationManagerBloc;
        },
      ),
    ];

  }

  @override
  ThemeData themeData(BuildContext context) {

    final ThemeData contextTheme = Theme.of(context);
    final ThemeData gameTheme = contextTheme.copyWith(
      primaryColor: gameColour,
      accentColor: gameAccentColour,
    );

    return gameTheme;

  }

  @override
  _GameDetailBody detailBodyBuilder() {

    return _GameDetailBody(
      onUpdate: onUpdate,
    );

  }

  BlocProvider<GameRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(GameRelationManagerBloc<W> managerBloc) {

    return BlocProvider<GameRelationBloc<W>>(
      create: (BuildContext context) {
        return GameRelationBloc<W>(
          itemID: item.ID,
          iCollectionRepository: ICollectionRepository.iCollectionRepository,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }

}

class _GameDetailBody extends ItemDetailBody<Game, GameDetailBloc, GameDetailManagerBloc> {
  _GameDetailBody({
    Key key,
    void Function(Game item) onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Game game) {

    return [
      itemTextField(
        context,
        fieldName: game_nameField,
        value: game.name,
      ),
      itemTextField(
        context,
        fieldName: game_editionField,
        value: game.edition,
      ),
      itemYearField(
        context,
        fieldName: game_releaseYearField,
        value: game.releaseYear,
      ),
      itemChipField(
        context,
        fieldName: game_statusField,
        value: game.status,
        possibleValues: statuses,
        possibleValuesColours: statusColours,
      ),
      itemRatingField(
        context,
        fieldName: game_ratingField,
        value: game.rating,
      ),
      itemLongTextField(
        context,
        fieldName: game_thoughtsField,
        value: game.thoughts,
      ),
      itemDurationField(
        context,
        fieldName: game_timeField,
        value: game.time,
      ),
      itemURLField(
        context,
        fieldName: game_saveFolderField,
        value: game.saveFolder,
      ),
      itemURLField(
        context,
        fieldName: game_screenshotFolderField,
        value: game.screenshotFolder,
      ),
      itemDateTimeField(
        context,
        fieldName: game_finishDateField,
        value: game.finishDate,
      ),
      itemBoolField(
        context,
        fieldName: game_backupField,
        value: game.isBackup,
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder() {

    return [
      GamePlatformRelationList(),
      GamePurchaseRelationList(),
      GameDLCRelationList(),
      GameTagRelationList(),
    ];

  }

}