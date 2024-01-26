import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart'
    show GameDTO, NewGameDTO, GameStatus;

import 'package:logic/model/model.dart' show ItemImage;
import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_detail/item_detail.dart';
import 'package:logic/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import '../route_constants.dart';
import '../relation/relation.dart';
import '../theme/theme.dart' show AppTheme, GameTheme;
import '../calendar/calendar_arguments.dart';
import 'item_detail.dart';
import 'play_time_field.dart';
import 'finish_date_list.dart';

class GameDetail extends ItemDetail<GameDTO, NewGameDTO, GameDetailBloc,
    GameDetailManagerBloc> {
  const GameDetail({
    Key? key,
    required super.item,
    super.onChange,
  }) : super(key: key);

  @override
  GameDetailBloc detailBlocBuilder(
    GameOClockService collectionService,
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
    GameOClockService collectionService,
  ) {
    return GameDetailManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );
  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameOClockService collectionService,
  ) {
    final GameLogRelationManagerBloc logRelationManagerBloc =
        GameLogRelationManagerBloc(
      itemId: item.id,
      collectionService: collectionService,
    );

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
      BlocProvider<GamePlayTimeRelationBloc>(
        create: (BuildContext context) {
          return GamePlayTimeRelationBloc(
            itemId: item.id,
            collectionService: collectionService,
            managerBloc: logRelationManagerBloc,
          )..add(LoadItemRelation());
        },
      ),
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
      BlocProvider<GameLogRelationManagerBloc>(
        create: (BuildContext context) {
          return logRelationManagerBloc;
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
      onChange: onChange,
    );
  }
}

// ignore: must_be_immutable
class _GameDetailBody extends ItemDetailBody<GameDTO, NewGameDTO,
    GameDetailBloc, GameDetailManagerBloc> {
  _GameDetailBody({
    Key? key,
    required this.itemId,
    super.onChange,
  }) : super(
          key: key,
          hasImage: GameTheme.hasImage,
        );

  final String itemId;

  @override
  String itemTitle(GameDTO item) => GameTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, GameDTO game) {
    final bool isNotWishlisted = game.status != GameStatus.wishlist;

    final List<Widget> fields = <Widget>[
      itemTextField(
        context,
        fieldName: AppLocalizations.of(context)!.nameFieldString,
        value: game.name,
        item: game,
        itemUpdater: (String newValue) => game.newWith(name: newValue),
      ),
      itemTextField(
        context,
        fieldName: AppLocalizations.of(context)!.editionFieldString,
        value: game.edition,
        item: game,
        itemUpdater: (String newValue) => game.newWith(edition: newValue),
      ),
      itemYearField(
        context,
        fieldName: AppLocalizations.of(context)!.releaseYearFieldString,
        value: game.releaseYear,
        item: game,
        itemUpdater: (int? newValue) =>
            game.newWith(releaseYear: newValue)..releaseYear = newValue,
      ),
    ];

    if (isNotWishlisted) {
      fields.addAll(<Widget>[
        itemChipField(
          context,
          fieldName: AppLocalizations.of(context)!.statusFieldString,
          value: GameStatus.values.indexOf(game.status),
          possibleValues: <String>[
            AppLocalizations.of(context)!.lowPriorityString,
            AppLocalizations.of(context)!.nextUpString,
            AppLocalizations.of(context)!.playingString,
            AppLocalizations.of(context)!.playedString,
          ],
          possibleValuesColours: GameTheme.statusColours,
          item: game,
          itemUpdater: (int newValue) =>
              game.newWith(status: GameStatus.values.elementAt(newValue)),
        ),
        itemRatingField(
          context,
          fieldName: AppLocalizations.of(context)!.ratingFieldString,
          value: game.rating,
          item: game,
          itemUpdater: (int newValue) => game.newWith(rating: newValue),
        ),
        itemLongTextField(
          context,
          fieldName: AppLocalizations.of(context)!.thoughtsFieldString,
          value: game.notes,
          item: game,
          itemUpdater: (String newValue) => game.newWith(notes: newValue),
        ),
        itemURLField(
          context,
          fieldName: AppLocalizations.of(context)!.saveFolderFieldString,
          value: game.saveFolder,
          item: game,
          itemUpdater: (String newValue) => game.newWith(saveFolder: newValue),
        ),
        itemURLField(
          context,
          fieldName: AppLocalizations.of(context)!.screenshotFolderFieldString,
          value: game.screenshotFolder,
          item: game,
          itemUpdater: (String newValue) =>
              game.newWith(screenshotFolder: newValue),
        ),
        itemBoolField(
          context,
          fieldName: AppLocalizations.of(context)!.backupFieldString,
          value: game.backup,
          item: game,
          itemUpdater: (bool newValue) => game.newWith(backup: newValue),
        ),
        _gameCalendarField(context),
        GameTotalPlayTimeField(
          fieldName: AppLocalizations.of(context)!.gameLogsFieldString,
          relationTypeName: AppLocalizations.of(context)!.gameLogsFieldString,
        ),
        GameFinishDateList(
          fieldName: AppLocalizations.of(context)!.finishDatesFieldString,
          relationTypeName: AppLocalizations.of(context)!.finishDateFieldString,
        ),
      ]);
    }

    return fields;
  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {
    return <Widget>[
      GamePlatformRelationList(
        relationName: AppLocalizations.of(context)!.platformsString,
        relationTypeName: AppLocalizations.of(context)!.platformString,
      ),
      GameDLCRelationList(
        relationName: AppLocalizations.of(context)!.dlcsString,
        relationTypeName: AppLocalizations.of(context)!.dlcString,
      ),
      GameTagRelationList(
        relationName: AppLocalizations.of(context)!.tagsString,
        relationTypeName: AppLocalizations.of(context)!.tagString,
      ),
    ];
  }

  @override
  List<Widget> itemSkeletonFieldsBuilder(BuildContext context) {
    int order = 0;

    return <Widget>[
      itemSkeletonLongTextField(
        fieldName: AppLocalizations.of(context)!.nameFieldString,
        order: order++,
      ),
      itemSkeletonLongTextField(
        fieldName: AppLocalizations.of(context)!.editionFieldString,
        order: order++,
      ),
      itemSkeletonField(
        fieldName: AppLocalizations.of(context)!.releaseYearFieldString,
        order: order++,
      ),
      itemSkeletonChipField(
        fieldName: AppLocalizations.of(context)!.statusFieldString,
        order: order++,
      ),
      itemSkeletonRatingField(
        fieldName: AppLocalizations.of(context)!.ratingFieldString,
        order: order++,
      ),
      itemSkeletonLongTextField(
        fieldName: AppLocalizations.of(context)!.thoughtsFieldString,
        order: order++,
      ),
      itemSkeletonLongTextField(
        fieldName: AppLocalizations.of(context)!.saveFolderFieldString,
        order: order++,
      ),
      itemSkeletonLongTextField(
        fieldName: AppLocalizations.of(context)!.screenshotFolderFieldString,
        order: order++,
      ),
      itemSkeletonField(
        fieldName: AppLocalizations.of(context)!.backupFieldString,
        order: order++,
      ),
      _gameCalendarField(context),
      GameTotalPlayTimeField(
        fieldName: AppLocalizations.of(context)!.gameLogsFieldString,
        relationTypeName: AppLocalizations.of(context)!.gameLogsFieldString,
        skeletonOrder: order++,
      ),
      GameFinishDateList(
        fieldName: AppLocalizations.of(context)!.finishDatesFieldString,
        relationTypeName: AppLocalizations.of(context)!.finishDateFieldString,
        skeletonOrder: order++,
      ),
    ];
  }

  Widget _gameCalendarField(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.singleCalendarViewString,
      ),
      trailing: const Icon(AppTheme.goIcon),
      onTap: () async {
        Navigator.pushNamed(
          context,
          gameSingleCalendarRoute,
          arguments: SingleGameCalendarArguments(
            itemId: itemId,
            onChange: () {
              reloadItem(context);
            },
          ),
        );
      },
    );
  }

  @override
  ItemImage buildItemImage(GameDTO item) {
    return ItemImage(item.coverUrl, item.coverFilename);
  }

  @override
  void reloadExtraFields(BuildContext context) {
    BlocProvider.of<GamePlayTimeRelationBloc>(context)
        .add(ReloadItemRelation());
    BlocProvider.of<GameFinishRelationBloc>(context).add(ReloadItemRelation());
  }
}

class GameFinishDateList
    extends FinishList<GameFinishRelationBloc, GameFinishRelationManagerBloc> {
  const GameFinishDateList({
    Key? key,
    required super.fieldName,
    required super.relationTypeName,
    super.skeletonOrder,
  }) : super(key: key);
}
