import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart'
    show GameDTO, NewGameDTO, GameStatus;

import 'package:backend/model/model.dart' show GameDetailed, ItemImage;
import 'package:backend/service/service.dart' show GameCollectionService;
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

class GameDetail extends ItemDetail<GameDetailed, NewGameDTO, GameDetailBloc,
    GameDetailManagerBloc> {
  const GameDetail({
    Key? key,
    required super.item,
    super.onUpdate,
  }) : super(key: key);

  @override
  GameDetailBloc detailBlocBuilder(
    GameCollectionService collectionService,
    GameDetailManagerBloc managerBloc,
  ) {
    return GameDetailBloc(
      itemId: item.id,
      collectionService: collectionService,
      managerBloc: managerBloc,
    );
  }

  @override
  GameDetailManagerBloc managerBlocBuilder(
    GameCollectionService collectionService,
  ) {
    return GameDetailManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameCollectionService collectionService,
  ) {
    final GameFinishRelationManagerBloc finishRelationManagerBloc =
        GameFinishRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    final GamePlatformRelationManagerBloc platformRelationManagerBloc =
        GamePlatformRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    final GameDLCRelationManagerBloc dlcRelationManagerBloc =
        GameDLCRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    final GameTagRelationManagerBloc tagRelationManagerBloc =
        GameTagRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      BlocProvider<GameFinishRelationBloc>(
        create: (BuildContext context) {
          return GameFinishRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: finishRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<GamePlatformRelationBloc>(
        create: (BuildContext context) {
          return GamePlatformRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: platformRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<GameDLCRelationBloc>(
        create: (BuildContext context) {
          return GameDLCRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: dlcRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<GameTagRelationBloc>(
        create: (BuildContext context) {
          return GameTagRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: tagRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
      BlocProvider<GameFinishRelationManagerBloc>(
        create: (BuildContext context) {
          return finishRelationManagerBloc;
        },
      ),
      BlocProvider<GamePlatformRelationManagerBloc>(
        create: (BuildContext context) {
          return platformRelationManagerBloc;
        },
      ),
      BlocProvider<GameDLCRelationManagerBloc>(
        create: (BuildContext context) {
          return dlcRelationManagerBloc;
        },
      ),
      BlocProvider<GameTagRelationManagerBloc>(
        create: (BuildContext context) {
          return tagRelationManagerBloc;
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
}

// ignore: must_be_immutable
class _GameDetailBody extends ItemDetailBody<GameDetailed, NewGameDTO,
    GameDetailBloc, GameDetailManagerBloc> {
  _GameDetailBody({
    Key? key,
    required this.itemId,
    super.onUpdate,
  }) : super(
          key: key,
          hasImage: GameTheme.hasImage,
        );

  final int itemId;

  @override
  String itemTitle(GameDTO item) => GameTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, GameDetailed game) {
    return <Widget>[
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        value: game.name,
        item: game,
        itemUpdater: (String newValue) => game.newWith(name: newValue),
      ),
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).editionFieldString,
        value: game.edition,
        item: game,
        itemUpdater: (String newValue) => game.newWith(edition: newValue),
      ),
      itemYearField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).releaseYearFieldString,
        value: game.releaseYear,
        item: game,
        itemUpdater: (int newValue) => game.newWith(releaseYear: newValue),
      ),
      itemChipField(
        context,
        fieldName: GameCollectionLocalisations.of(context).statusFieldString,
        value: GameStatus.values.indexOf(game.status),
        possibleValues: <String>[
          GameCollectionLocalisations.of(context).lowPriorityString,
          GameCollectionLocalisations.of(context).nextUpString,
          GameCollectionLocalisations.of(context).playingString,
          GameCollectionLocalisations.of(context).playedString,
        ],
        possibleValuesColours: GameTheme.statusColours,
        item: game,
        itemUpdater: (int newValue) =>
            game.newWith(status: GameStatus.values.elementAt(newValue)),
      ),
      itemRatingField(
        context,
        fieldName: GameCollectionLocalisations.of(context).ratingFieldString,
        value: game.rating,
        item: game,
        itemUpdater: (int newValue) => game.newWith(rating: newValue),
      ),
      itemLongTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).thoughtsFieldString,
        value: game.notes,
        item: game,
        itemUpdater: (String newValue) => game.newWith(notes: newValue),
      ),
      itemURLField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).saveFolderFieldString,
        value: game.saveFolder,
        item: game,
        itemUpdater: (String newValue) => game.newWith(saveFolder: newValue),
      ),
      itemURLField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).screenshotFolderFieldString,
        value: game.screenshotFolder,
        item: game,
        itemUpdater: (String newValue) =>
            game.newWith(screenshotFolder: newValue),
      ),
      itemBoolField(
        context,
        fieldName: GameCollectionLocalisations.of(context).backupFieldString,
        value: game.backup,
        item: game,
        itemUpdater: (bool newValue) => game.newWith(backup: newValue),
      ),
      _gameCalendarField(context),
      itemDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).gameLogsFieldString,
        value: game.totalTime,
      ),
      GameFinishDateList(
        fieldName:
            GameCollectionLocalisations.of(context).finishDatesFieldString,
        value: game.firstFinish,
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
      GameDLCRelationList(
        relationName: GameCollectionLocalisations.of(context).dlcsString,
        relationTypeName: GameCollectionLocalisations.of(context).dlcString,
      ),
      GameTagRelationList(
        relationName: GameCollectionLocalisations.of(context).tagsString,
        relationTypeName: GameCollectionLocalisations.of(context).tagString,
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
        fieldName: GameCollectionLocalisations.of(context).gameLogsFieldString,
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
        onTap: () async {
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

  @override
  ItemImage buildItemImage(GameDetailed item) {
    return ItemImage(item.coverUrl, item.coverFilename);
  }
}

// ignore: must_be_immutable
class GameFinishDateList
    extends FinishList<GameFinishRelationBloc, GameFinishRelationManagerBloc> {
  GameFinishDateList({
    Key? key,
    required super.fieldName,
    required super.value,
    required super.relationTypeName,
    required super.onUpdate,
  }) : super(key: key);
}

// ignore: must_be_immutable
class SkeletonGameFinishDateList extends SkeletonFinishList<
    GameFinishRelationBloc, GameFinishRelationManagerBloc> {
  SkeletonGameFinishDateList({
    Key? key,
    required super.fieldName,
    required super.relationTypeName,
    required super.order,
    required super.onUpdate,
  }) : super(key: key);
}
