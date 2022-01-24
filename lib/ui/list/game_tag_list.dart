import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/repository/repository.dart' show GameCollectionRepository;

import 'package:backend/model/model.dart' show GameTag;
import 'package:backend/model/list_style.dart';

import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTagTheme;
import 'list.dart';


class GameTagList extends StatelessWidget {
  const GameTagList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final GameCollectionRepository _collectionRepository = RepositoryProvider.of<GameCollectionRepository>(context);

    final GameTagListManagerBloc _gameTagListManagerBloc = GameTagListManagerBloc(
      collectionRepository: _collectionRepository,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<GameTagListBloc>(
          create: (BuildContext context) {
            return GameTagListBloc(
              collectionRepository: _collectionRepository,
              managerBloc: _gameTagListManagerBloc,
            )..add(LoadItemList());
          },
        ),

        BlocProvider<GameTagListManagerBloc>(
          create: (BuildContext context) {
            return _gameTagListManagerBloc;
          },
        ),
      ],
      child: const Scaffold(
        appBar: _GameTagAppBar(),
        body: _GameTagList(),
        floatingActionButton: _GameTagFAB(),
      ),
    );

  }
}

class _GameTagAppBar extends ItemAppBar<GameTag, GameTagListBloc> {
  const _GameTagAppBar({
    Key? key,
  }) : super(
    key: key,
    themeColor: GameTagTheme.primaryColour,
    gridAllowed: false,
  );

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).gameTagsString;

  @override
  List<String> views(BuildContext context) => GameTagTheme.views(context);
}

class _GameTagFAB extends ItemFAB<GameTag, GameTagListManagerBloc> {
  const _GameTagFAB({
    Key? key,
  }) : super(
    key: key,
    themeColor: GameTagTheme.primaryColour,
  );

  @override
  GameTag createItem() => const GameTag(id: -1, name: '');

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).gameTagString;
}

class _GameTagList extends ItemList<GameTag, GameTagListBloc, GameTagListManagerBloc> {
  const _GameTagList({
    Key? key,
  }) : super(
    key: key,
    detailRouteName: gameTagDetailRoute,
  );

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).gameTagString;

  @override
  _GameTagListBody itemListBodyBuilder({required List<GameTag> items, required int viewIndex, required int viewYear, required void Function(GameTag) onDelete, required ListStyle style, required ScrollController scrollController}) {

    return _GameTagListBody(
      items: items,
      viewIndex: viewIndex,
      viewYear: viewYear,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );

  }
}

class _GameTagListBody extends ItemListBody<GameTag, GameTagListBloc> {
  const _GameTagListBody({
    Key? key,
    required List<GameTag> items,
    required int viewIndex,
    required int viewYear,
    required void Function(GameTag) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    viewYear: viewYear,
    onDelete: onDelete,
    style: style,
    scrollController: scrollController,
    detailRouteName: gameTagDetailRoute,
    localSearchRouteName: gameTagLocalSearchRoute,
  );

  @override
  String itemTitle(GameTag item) => GameTagTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) => GameTagTheme.views(context).elementAt(viewIndex);

  @override
  Widget cardBuilder(BuildContext context, GameTag item) => GameTagTheme.itemTile(context, item, onTap);
}