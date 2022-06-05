import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart'
    show Item, Game, GameStatus, GameFinish, DLC, Purchase, Platform, GameTag;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../relation/relation.dart';
import '../theme/theme.dart' show GameTheme;
import '../calendar/calendar_arguments.dart';
import 'item_detail.dart';
import 'finish_date_list.dart';

class GameDetail
    extends ItemDetail<Game, GameDetailBloc, GameDetailManagerBloc> {
  const GameDetail({
    Key? key,
    required Game item,
    void Function(Game? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  GameDetailBloc detailBlocBuilder(
    GameCollectionRepository collectionRepository,
    GameDetailManagerBloc managerBloc,
  ) {
    return GameDetailBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
      managerBloc: managerBloc,
    );
  }

  @override
  GameDetailManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return GameDetailManagerBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    final GameRelationManagerBloc<Platform> platformRelationManagerBloc =
        GameRelationManagerBloc<Platform>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final GameRelationManagerBloc<Purchase> purchaseRelationManagerBloc =
        GameRelationManagerBloc<Purchase>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final GameRelationManagerBloc<DLC> dlcRelationManagerBloc =
        GameRelationManagerBloc<DLC>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final GameRelationManagerBloc<GameTag> tagRelationManagerBloc =
        GameRelationManagerBloc<GameTag>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final GameRelationManagerBloc<GameFinish> finishRelationManagerBloc =
        GameRelationManagerBloc<GameFinish>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      blocProviderRelationBuilder<Platform>(
        collectionRepository,
        platformRelationManagerBloc,
      ),
      blocProviderRelationBuilder<Purchase>(
        collectionRepository,
        purchaseRelationManagerBloc,
      ),
      blocProviderRelationBuilder<DLC>(
        collectionRepository,
        dlcRelationManagerBloc,
      ),
      blocProviderRelationBuilder<GameTag>(
        collectionRepository,
        tagRelationManagerBloc,
      ),
      blocProviderRelationBuilder<GameFinish>(
        collectionRepository,
        finishRelationManagerBloc,
      ),
      BlocProvider<GameRelationManagerBloc<Platform>>(
        create: (BuildContext context) {
          return platformRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<Purchase>>(
        create: (BuildContext context) {
          return purchaseRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<DLC>>(
        create: (BuildContext context) {
          return dlcRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<GameTag>>(
        create: (BuildContext context) {
          return tagRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<GameFinish>>(
        create: (BuildContext context) {
          return finishRelationManagerBloc;
        },
      ),
    ];
  }

  @override
  // ignore: library_private_types_in_public_api
  _GameDetailBody detailBodyBuilder() {
    return _GameDetailBody(
      itemId: item.id,
      onUpdate: onUpdate,
    );
  }

  BlocProvider<GameRelationBloc<W>> blocProviderRelationBuilder<W extends Item>(
    GameCollectionRepository collectionRepository,
    GameRelationManagerBloc<W> managerBloc,
  ) {
    return BlocProvider<GameRelationBloc<W>>(
      create: (BuildContext context) {
        return GameRelationBloc<W>(
          itemId: item.id,
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );
  }
}

// ignore: must_be_immutable
class _GameDetailBody
    extends ItemDetailBody<Game, GameDetailBloc, GameDetailManagerBloc> {
  _GameDetailBody({
    Key? key,
    required this.itemId,
    void Function(Game? item)? onUpdate,
  }) : super(
          key: key,
          onUpdate: onUpdate,
          hasImage: Game.hasImage,
        );

  final int itemId;

  @override
  String itemTitle(Game item) => GameTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Game game) {
    return <Widget>[
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        value: game.name,
        item: game,
        itemUpdater: (String newValue) => game.copyWith(name: newValue),
      ),
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).editionFieldString,
        value: game.edition,
        item: game,
        itemUpdater: (String newValue) => game.copyWith(edition: newValue),
      ),
      itemYearField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).releaseYearFieldString,
        value: game.releaseYear,
        item: game,
        itemUpdater: (int newValue) => game.copyWith(releaseYear: newValue),
      ),
      itemChipField(
        context,
        fieldName: GameCollectionLocalisations.of(context).statusFieldString,
        value: game.status.index,
        possibleValues: <String>[
          GameCollectionLocalisations.of(context).lowPriorityString,
          GameCollectionLocalisations.of(context).nextUpString,
          GameCollectionLocalisations.of(context).playingString,
          GameCollectionLocalisations.of(context).playedString,
        ],
        possibleValuesColours: GameTheme.statusColours,
        item: game,
        itemUpdater: (int newValue) =>
            game.copyWith(status: GameStatus.values.elementAt(newValue)),
      ),
      itemRatingField(
        context,
        fieldName: GameCollectionLocalisations.of(context).ratingFieldString,
        value: game.rating,
        item: game,
        itemUpdater: (int newValue) => game.copyWith(rating: newValue),
      ),
      itemLongTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).thoughtsFieldString,
        value: game.thoughts,
        item: game,
        itemUpdater: (String newValue) => game.copyWith(thoughts: newValue),
      ),
      itemURLField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).saveFolderFieldString,
        value: game.saveFolder,
        item: game,
        itemUpdater: (String newValue) => game.copyWith(saveFolder: newValue),
      ),
      itemURLField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).screenshotFolderFieldString,
        value: game.screenshotFolder,
        item: game,
        itemUpdater: (String newValue) =>
            game.copyWith(screenshotFolder: newValue),
      ),
      itemBoolField(
        context,
        fieldName: GameCollectionLocalisations.of(context).backupFieldString,
        value: game.isBackup,
        item: game,
        itemUpdater: (bool newValue) => game.copyWith(isBackup: newValue),
      ),
      _gameCalendarField(context),
      itemDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).timeLogsFieldString,
        value: game.totalTime,
      ),
      GameFinishDateList(
        fieldName:
            GameCollectionLocalisations.of(context).finishDatesFieldString,
        value: game.firstFinishDate,
        relationTypeName:
            GameCollectionLocalisations.of(context).finishDateFieldString,
        onUpdate: () {
          BlocProvider.of<GameDetailBloc>(context).add(ReloadItem());
        },
      ),
    ];
  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {
    return <Widget>[
      GamePlatformRelationList(
        relationName: GameCollectionLocalisations.of(context).platformsString,
        relationTypeName:
            GameCollectionLocalisations.of(context).platformString,
      ),
      GamePurchaseRelationList(
        relationName: GameCollectionLocalisations.of(context).purchasesString,
        relationTypeName:
            GameCollectionLocalisations.of(context).purchaseString,
      ),
      GameDLCRelationList(
        relationName: GameCollectionLocalisations.of(context).dlcsString,
        relationTypeName: GameCollectionLocalisations.of(context).dlcString,
      ),
      GameTagRelationList(
        relationName: GameCollectionLocalisations.of(context).gameTagsString,
        relationTypeName: GameCollectionLocalisations.of(context).gameTagString,
      ),
    ];
  }

  @override
  List<Widget> itemSkeletonFieldsBuilder(BuildContext context) {
    int order = 0;

    return <Widget>[
      itemSkeletonField(
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        order: order++,
      ),
      itemSkeletonField(
        fieldName: GameCollectionLocalisations.of(context).editionFieldString,
        order: order++,
      ),
      itemSkeletonField(
        fieldName:
            GameCollectionLocalisations.of(context).releaseYearFieldString,
        order: order++,
      ),
      itemSkeletonChipField(
        fieldName: GameCollectionLocalisations.of(context).statusFieldString,
        order: order++,
      ),
      itemSkeletonRatingField(
        fieldName: GameCollectionLocalisations.of(context).ratingFieldString,
        order: order++,
      ),
      itemSkeletonLongTextField(
        fieldName: GameCollectionLocalisations.of(context).thoughtsFieldString,
        order: order++,
      ),
      itemSkeletonField(
        fieldName:
            GameCollectionLocalisations.of(context).saveFolderFieldString,
        order: order++,
      ),
      itemSkeletonField(
        fieldName:
            GameCollectionLocalisations.of(context).screenshotFolderFieldString,
        order: order++,
      ),
      itemSkeletonField(
        fieldName: GameCollectionLocalisations.of(context).backupFieldString,
        order: order++,
      ),
      _gameCalendarField(context),
      itemSkeletonField(
        fieldName: GameCollectionLocalisations.of(context).timeLogsFieldString,
        order: order++,
      ),
      SkeletonGameFinishDateList(
        fieldName:
            GameCollectionLocalisations.of(context).finishDatesFieldString,
        relationTypeName:
            GameCollectionLocalisations.of(context).finishDateFieldString,
        order: order++,
        onUpdate: () {
          BlocProvider.of<GameDetailBloc>(context).add(ReloadItem());
        },
      ),
    ];
  }

  Widget _gameCalendarField(BuildContext context) {
    return ListTileTheme.merge(
      child: ListTile(
        title: Text(
          GameCollectionLocalisations.of(context).singleCalendarViewString,
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.pushNamed(
            context,
            gameSingleCalendarRoute,
            arguments: SingleGameCalendarArguments(
              itemId: itemId,
              onUpdate: () {
                BlocProvider.of<GameDetailBloc>(context).add(ReloadItem());
              },
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class GameFinishDateList extends FinishList<GameFinish,
    GameRelationBloc<GameFinish>, GameRelationManagerBloc<GameFinish>> {
  GameFinishDateList({
    Key? key,
    required super.fieldName,
    required super.value,
    required super.relationTypeName,
    required super.onUpdate,
  }) : super(key: key);

  @override
  GameFinish createFinish(DateTime dateTime) => GameFinish(dateTime: dateTime);
}

// ignore: must_be_immutable
class SkeletonGameFinishDateList extends SkeletonFinishList<GameFinish,
    GameRelationBloc<GameFinish>, GameRelationManagerBloc<GameFinish>> {
  SkeletonGameFinishDateList({
    Key? key,
    required super.fieldName,
    required super.relationTypeName,
    required super.order,
    required super.onUpdate,
  }) : super(key: key);

  @override
  GameFinish createFinish(DateTime dateTime) => GameFinish(dateTime: dateTime);
}
