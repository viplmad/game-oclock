import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart' show TagDTO, NewTagDTO;

import 'package:backend/service/service.dart' show GameCollectionService;
import 'package:backend/model/model.dart' show ListStyle;
import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show TagTheme;
import 'list.dart';

class TagList extends StatelessWidget {
  const TagList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameCollectionService collectionService =
        RepositoryProvider.of<GameCollectionService>(context);

    final TagListManagerBloc gameTagListManagerBloc = TagListManagerBloc(
      collectionService: collectionService,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<TagListBloc>(
          create: (BuildContext context) {
            return TagListBloc(
              collectionService: collectionService,
              managerBloc: gameTagListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<TagListManagerBloc>(
          create: (BuildContext context) {
            return gameTagListManagerBloc;
          },
        ),
      ],
      child: const Scaffold(
        appBar: _TagAppBar(),
        body: _TagList(),
        floatingActionButton: _TagFAB(),
      ),
    );
  }
}

class _TagAppBar extends ItemAppBar<TagDTO, TagListBloc> {
  const _TagAppBar({
    Key? key,
  }) : super(
          key: key,
          themeColor: TagTheme.primaryColour,
          gridAllowed: TagTheme.hasImage,
          searchRouteName: tagSearchRoute,
          detailRouteName: tagDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).tagString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).tagsString;

  @override
  List<String> views(BuildContext context) => TagTheme.views(context);
}

class _TagFAB extends ItemFAB<TagDTO, NewTagDTO, TagListManagerBloc> {
  const _TagFAB({
    Key? key,
  }) : super(
          key: key,
          themeColor: TagTheme.secondaryColour,
        );

  @override
  NewTagDTO createItem() => NewTagDTO(name: '');

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).tagString;
}

class _TagList extends ItemList<TagDTO, TagListBloc, TagListManagerBloc> {
  const _TagList({
    Key? key,
  }) : super(
          key: key,
          detailRouteName: tagDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).tagString;

  @override
  _GameTagListBody itemListBodyBuilder({
    required List<TagDTO> items,
    required int viewIndex,
    required Object? viewArgs,
    required void Function(TagDTO) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _GameTagListBody(
      items: items,
      viewIndex: viewIndex,
      viewArgs: viewArgs,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _GameTagListBody extends ItemListBody<TagDTO, TagListBloc> {
  const _GameTagListBody({
    Key? key,
    required super.items,
    required super.viewIndex,
    required super.viewArgs,
    required super.onDelete,
    required super.style,
    required super.scrollController,
  }) : super(
          key: key,
          detailRouteName: tagDetailRoute,
          searchRouteName: tagSearchRoute,
        );

  @override
  String itemTitle(TagDTO item) => TagTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) =>
      TagTheme.views(context).elementAt(viewIndex);

  @override
  Widget cardBuilder(BuildContext context, TagDTO item) =>
      TagTheme.itemTile(context, item, onTap);
}
