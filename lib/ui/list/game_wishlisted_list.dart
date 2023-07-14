import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sliver_tools/sliver_tools.dart';

import 'package:game_collection_client/api.dart'
    show GameDTO, GameStatus, NewGameDTO, PrimaryModel;

import 'package:logic/model/model.dart' show ListStyle;
import 'package:logic/service/service.dart' show GameCollectionService;
import 'package:logic/bloc/item_list/item_list.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/ui/common/item_view.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;
import 'list.dart';

class GameWishlistedList extends StatelessWidget {
  const GameWishlistedList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameCollectionService collectionService =
        RepositoryProvider.of<GameCollectionService>(context);

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
  const _GameWishlistedAppBar({
    Key? key,
  }) : super(
          key: key,
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
  const _GameWishlistedFAB({
    Key? key,
  }) : super(
          key: key,
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
  const _GameWishlistedList({
    Key? key,
  }) : super(
          key: key,
          detailRouteName: gameDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.wishedGameString;

  @override
  _GameWishlistedListBody itemListBodyBuilder({
    required List<GameDTO> items,
    required int viewIndex,
    required Object? viewArgs,
    required void Function(GameDTO) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _GameWishlistedListBody(
      items: items,
      viewIndex: viewIndex,
      viewArgs: viewArgs,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _GameWishlistedListBody
    extends ItemListBody<GameDTO, GameWishlistedListBloc> {
  const _GameWishlistedListBody({
    Key? key,
    required super.items,
    required super.viewIndex,
    required super.viewArgs,
    required super.onDelete,
    required super.style,
    required super.scrollController,
  }) : super(
          key: key,
          detailRouteName: gameDetailRoute,
        );

  @override
  Widget listBuilder(BuildContext context, ScrollController scrollController) {
    final Map<int, List<GameDTO>> yearGamesMap = <int, List<GameDTO>>{};
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
              );
          }
        },
      ).toList(growable: false),
    );
  }

  @override
  String itemTitle(GameDTO item) => GameTheme.itemTitle(item);

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
    Key? key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onDismiss,
    required this.confirmDelete,
  }) : super(key: key);

  final String title;
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T item) onDismiss;
  final Widget Function(BuildContext, T) confirmDelete;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        SliverPinnedHeader(child: ListTile(title: Text(title))),
        SliverList.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(
                right: 4.0,
                left: 4.0,
                bottom: 4.0,
                top: 4.0,
              ),
              child: itemInnerBuilder(context, index),
            );
          },
        )
      ],
    );
  }

  Widget itemInnerBuilder(BuildContext context, int index) {
    final T item = items.elementAt(index);

    return DismissibleItem(
      dismissibleKey: item.id,
      itemWidget: itemBuilder(context, item),
      onDismissed: (DismissDirection direction) {
        onDismiss(item);
      },
      confirmDismiss: (DismissDirection direction) async {
        return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return confirmDelete(context, item);
          },
        ).then((bool? value) => value ?? false);
      },
      dismissIcon: Icons.delete,
    );
  }
}

class ItemSliverGridSection<T extends PrimaryModel> extends StatelessWidget {
  const ItemSliverGridSection({
    Key? key,
    required this.title,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  final String title;
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        SliverPinnedHeader(child: ListTile(title: Text(title))),
        SliverGrid.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width / 200).ceil(),
          ),
          itemBuilder: (BuildContext context, int index) {
            final T item = items[index];

            return itemBuilder(context, item);
          },
        )
      ],
    );
  }
}
