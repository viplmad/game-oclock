import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart'
    show GameDTO, GameStatus, NewGameDTO, PrimaryModel;

import 'package:logic/model/model.dart' show ListStyle;
import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_list/item_list.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_oclock/ui/common/item_view.dart';
import 'package:game_oclock/ui/common/list_view.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show AppTheme, GameTheme;
import 'list.dart';

class GameWishlistedList extends StatelessWidget {
  const GameWishlistedList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GameOClockService collectionService =
        RepositoryProvider.of<GameOClockService>(context);

    final GameListManagerBloc gameListManagerBloc = GameListManagerBloc(
      collectionService: collectionService,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<GameWishlistedListBloc>(
          create: (BuildContext context) {
            return GameWishlistedListBloc(
              collectionService: collectionService,
              managerBloc: gameListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<GameListManagerBloc>(
          create: (BuildContext context) {
            return gameListManagerBloc;
          },
        ),
      ],
      child: const Scaffold(
        appBar: _GameWishlistedAppBar(),
        body: _GameWishlistedList(),
        floatingActionButton: _GameWishlistedFAB(),
      ),
    );
  }
}

class _GameWishlistedAppBar
    extends ItemAppBar<GameDTO, GameWishlistedListBloc> {
  const _GameWishlistedAppBar()
      : super(
          themeColor: GameTheme.primaryColour,
          gridAllowed: GameTheme.hasImage,
          searchRouteName: gameWishlistedSearchRoute,
          detailRouteName: gameDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.wishedGameString;

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.wishlistedGamesString;

  @override
  List<String> views(BuildContext context) => <String>[];
}

class _GameWishlistedFAB
    extends ItemFAB<GameDTO, NewGameDTO, GameListManagerBloc> {
  const _GameWishlistedFAB()
      : super(
          themeColor: GameTheme.secondaryColour,
        );

  @override
  NewGameDTO createItem() => NewGameDTO(name: '', status: GameStatus.wishlist);

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.wishedGameString;
}

class _GameWishlistedList
    extends ItemList<GameDTO, GameWishlistedListBloc, GameListManagerBloc> {
  const _GameWishlistedList()
      : super(
          detailRouteName: gameDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.wishedGameString;

  @override
  _GameWishlistedListBody itemListBodyBuilder({
    required List<GameDTO> items,
    required int viewIndex,
    required void Function(GameDTO) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _GameWishlistedListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _GameWishlistedListBody
    extends ItemListBody<GameDTO, GameWishlistedListBloc> {
  const _GameWishlistedListBody({
    required super.items,
    required super.viewIndex,
    required super.onDelete,
    required super.style,
    required super.scrollController,
  }) : super(
          detailRouteName: gameDetailRoute,
        );

  @override
  Widget listBuilder(BuildContext context, ScrollController scrollController) {
    final SplayTreeMap<int, List<GameDTO>> yearGamesMap =
        SplayTreeMap<int, List<GameDTO>>();
    for (final GameDTO game in items) {
      final int releaseYear = game.releaseYear ?? -1;
      final List<GameDTO> yearGames = yearGamesMap[releaseYear] ?? <GameDTO>[];
      yearGames.add(game);
      yearGamesMap[releaseYear] = yearGames;
    }

    return CustomScrollView(
      shrinkWrap: true,
      controller: scrollController,
      slivers: yearGamesMap.entries.map(
        (MapEntry<int, List<GameDTO>> yearGames) {
          final String sectionTitle = yearGames.key < 0
              ? AppLocalizations.of(context)!.noYearString
              : MaterialLocalizations.of(context)
                  .formatYear(DateTime(yearGames.key));

          switch (style) {
            case ListStyle.card:
              return ItemSliverCardSection<GameDTO>(
                title: sectionTitle,
                items: yearGames.value,
                itemBuilder: cardBuilder,
                onDismiss: onDelete,
                confirmDelete: confirmDelete,
              );
            case ListStyle.grid:
              return ItemSliverGridSection<GameDTO>(
                title: sectionTitle,
                items: yearGames.value,
                itemBuilder: gridBuilder,
                onDismiss: onDelete,
                confirmDelete: confirmDelete,
              );
          }
        },
      ).toList(growable: false),
    );
  }

  @override
  String itemTitle(GameDTO item) => GameTheme.itemTitle(item);

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.wishlistedGamesString;

  @override
  String viewTitle(BuildContext context) => '';

  @override
  Widget cardBuilder(BuildContext context, GameDTO item) =>
      GameTheme.itemCard(context, item, onTap);

  @override
  Widget gridBuilder(BuildContext context, GameDTO item) =>
      GameTheme.itemGrid(context, item, onTap);
}

class ItemSliverCardSection<T extends PrimaryModel> extends StatelessWidget {
  const ItemSliverCardSection({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onDismiss,
    required this.confirmDelete,
  });

  final String title;
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T item) onDismiss;
  final Widget Function(BuildContext, T) confirmDelete;

  @override
  Widget build(BuildContext context) {
    return ItemSliverCardSectionBuilder(
      title: title,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final T item = items.elementAt(index);

        return DismissibleItem(
          itemWidget: itemBuilder(context, item),
          onDismissed: () {
            onDismiss(item);
          },
          confirmDismiss: () async {
            return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return confirmDelete(context, item);
              },
            ).then((bool? value) => value ?? false);
          },
          dismissIcon: AppTheme.deleteIcon,
          dismissLabel: AppLocalizations.of(context)!.deleteString,
        );
      },
    );
  }
}

class ItemSliverGridSection<T extends PrimaryModel> extends StatelessWidget {
  const ItemSliverGridSection({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onDismiss,
    required this.confirmDelete,
  });

  final String title;
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T item) onDismiss;
  final Widget Function(BuildContext, T) confirmDelete;

  @override
  Widget build(BuildContext context) {
    return ItemSliverGridSectionBuilder(
      title: title,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final T item = items.elementAt(index);

        return DismissibleItem(
          itemWidget: itemBuilder(context, item),
          onDismissed: () {
            onDismiss(item);
          },
          confirmDismiss: () async {
            return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return confirmDelete(context, item);
              },
            ).then((bool? value) => value ?? false);
          },
          dismissIcon: AppTheme.deleteIcon,
          dismissLabel: AppLocalizations.of(context)!.deleteString,
        );
      },
    );
  }
}
