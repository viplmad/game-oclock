import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show Item, Game, GameStatus, GameFinish, DLC, Purchase, Platform, GameTag;
import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../relation/relation.dart';
import '../theme/theme.dart' show GameTheme;
import '../calendar/calendar.dart';
import 'item_detail.dart';
import 'finish_date_list.dart';


class GameDetail extends ItemDetail<Game, GameDetailBloc, GameDetailManagerBloc> {
  const GameDetail({
    Key? key,
    required Game item,
    void Function(Game? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  GameDetailBloc detailBlocBuilder(GameCollectionRepository collectionRepository, GameDetailManagerBloc managerBloc) {

    return GameDetailBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
      managerBloc: managerBloc,
    );

  }

  @override
  GameDetailManagerBloc managerBlocBuilder(GameCollectionRepository collectionRepository) {

    return GameDetailManagerBloc(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

  }

  @override
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(GameCollectionRepository collectionRepository) {

    final GameRelationManagerBloc<Platform> _platformRelationManagerBloc = GameRelationManagerBloc<Platform>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final GameRelationManagerBloc<Purchase> _purchaseRelationManagerBloc = GameRelationManagerBloc<Purchase>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final GameRelationManagerBloc<DLC> _dlcRelationManagerBloc = GameRelationManagerBloc<DLC>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final GameRelationManagerBloc<GameTag> _tagRelationManagerBloc = GameRelationManagerBloc<GameTag>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    final GameRelationManagerBloc<GameFinish> _finishRelationManagerBloc = GameRelationManagerBloc<GameFinish>(
      itemId: item.id,
      collectionRepository: collectionRepository,
    );

    return <BlocProvider<BlocBase<Object?>>>[
      blocProviderRelationBuilder<Platform>(collectionRepository, _platformRelationManagerBloc),
      blocProviderRelationBuilder<Purchase>(collectionRepository, _purchaseRelationManagerBloc),
      blocProviderRelationBuilder<DLC>(collectionRepository, _dlcRelationManagerBloc),
      blocProviderRelationBuilder<GameTag>(collectionRepository, _tagRelationManagerBloc),
      blocProviderRelationBuilder<GameFinish>(collectionRepository, _finishRelationManagerBloc),

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
      BlocProvider<GameRelationManagerBloc<GameTag>>(
        create: (BuildContext context) {
          return _tagRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<GameFinish>>(
        create: (BuildContext context) {
          return _finishRelationManagerBloc;
        },
      ),
    ];

  }

  @override
  _GameDetailBody detailBodyBuilder() {

    return _GameDetailBody(
      itemId: item.id,
      onUpdate: onUpdate,
    );

  }

  BlocProvider<GameRelationBloc<W>> blocProviderRelationBuilder<W extends Item>(GameCollectionRepository collectionRepository, GameRelationManagerBloc<W> managerBloc) {

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
class _GameDetailBody extends ItemDetailBody<Game, GameDetailBloc, GameDetailManagerBloc> {
  _GameDetailBody({
    Key? key,
    required this.itemId,
    void Function(Game? item)? onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

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
        fieldName: GameCollectionLocalisations.of(context).releaseYearFieldString,
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
        itemUpdater: (int newValue) => game.copyWith(status: GameStatus.values.elementAt(newValue)),
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
        fieldName: GameCollectionLocalisations.of(context).saveFolderFieldString,
        value: game.saveFolder,
        item: game,
        itemUpdater: (String newValue) => game.copyWith(saveFolder: newValue),
      ),
      itemURLField(
        context,
        fieldName: GameCollectionLocalisations.of(context).screenshotFolderFieldString,
        value: game.screenshotFolder,
        item: game,
        itemUpdater: (String newValue) => game.copyWith(screenshotFolder: newValue),
      ),
      itemBoolField(
        context,
        fieldName: GameCollectionLocalisations.of(context).backupFieldString,
        value: game.isBackup,
        item: game,
        itemUpdater: (bool newValue) => game.copyWith(isBackup: newValue),
      ),
      ListTileTheme.merge(
        child: ListTile(
          title: Text(GameCollectionLocalisations.of(context).singleCalendarViewString),
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
      ),
      itemDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).timeLogsFieldString,
        value: game.time,
      ),
      GameFinishDateList(
        fieldName: GameCollectionLocalisations.of(context).finishDatesFieldString,
        value: game.finishDate,
        relationTypeName: GameCollectionLocalisations.of(context).finishDateFieldString,
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
        relationTypeName: GameCollectionLocalisations.of(context).platformString,
      ),
      GamePurchaseRelationList(
        relationName: GameCollectionLocalisations.of(context).purchasesString,
        relationTypeName: GameCollectionLocalisations.of(context).purchaseString,
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
}

// ignore: must_be_immutable
class GameFinishDateList extends FinishList<Game, GameFinish, GameRelationBloc<GameFinish>, GameRelationManagerBloc<GameFinish>> {
  GameFinishDateList({
    Key? key,
    required String fieldName,
    required DateTime? value,
    required String relationTypeName,
    required void Function() onUpdate,
  }) : super(key: key, fieldName: fieldName, value: value, relationTypeName: relationTypeName, onUpdate: onUpdate);

  @override
  GameFinish createFinish(DateTime dateTime) => GameFinish(dateTime: dateTime);
}