import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/header_text.dart';
import '../common/list_view.dart';
import '../common/show_snackbar.dart';
import '../common/item_view.dart';
import '../detail/detail_arguments.dart';
import '../search/search_arguments.dart';
import '../theme/app_theme.dart';
import '../theme/theme_utils.dart';

// TODO check only bloc are used in other base classes
abstract class ItemRelationList<
        W extends PrimaryModel,
        K extends Bloc<ItemRelationEvent, ItemRelationState>,
        S extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState>>
    extends StatelessWidget {
  const ItemRelationList({
    Key? key,
    required this.relationName,
    required this.relationTypeName,
    this.trailingBuilder,
    this.limitHeight = true,
    this.isSingleList = false,
    required this.hasImage,
    required this.detailRouteName,
    required this.searchRouteName,
  }) : super(key: key);

  final String relationName;
  final String relationTypeName;
  final List<Widget> Function(List<W>)? trailingBuilder;
  final bool limitHeight;
  final bool isSingleList;
  final bool hasImage;

  final String detailRouteName;
  final String searchRouteName;

  @override
  Widget build(BuildContext context) {
    return BlocListener<S, ItemRelationManagerState>(
      listener: (BuildContext context, ItemRelationManagerState state) {
        if (state is ItemRelationAdded<W>) {
          final String message = GameCollectionLocalisations.of(context)
              .linkedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
            snackBarAction: backgroundSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).undoString,
              onPressed: () {
                try {
                  BlocProvider.of<S>(context).add(
                    DeleteItemRelation<W>(
                      state.otherItem,
                    ),
                  );
                } on FlutterError {
                  // Catch error when undoing if bloc is no longer in context
                  final String unableMessage =
                      GameCollectionLocalisations.of(context)
                          .unableToUndoString;
                  showSnackBar(
                    context,
                    message: unableMessage,
                  );
                }
              },
            ),
          );
        }
        if (state is ItemRelationNotAdded) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToLinkString(relationTypeName);
          showSnackBar(
            context,
            message: message,
            snackBarAction: dialogSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).moreString,
              title: message,
              content: state.error,
            ),
          );
        }
        if (state is ItemRelationDeleted<W>) {
          final String message = GameCollectionLocalisations.of(context)
              .unlinkedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
            snackBarAction: backgroundSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).undoString,
              onPressed: () {
                try {
                  BlocProvider.of<S>(context).add(
                    AddItemRelation<W>(
                      state.otherItem,
                    ),
                  );
                } on FlutterError {
                  // Catch error when undoing if bloc is no longer in context
                  final String unableMessage =
                      GameCollectionLocalisations.of(context)
                          .unableToUndoString;
                  showSnackBar(
                    context,
                    message: unableMessage,
                  );
                }
              },
            ),
          );
        }
        if (state is ItemRelationNotDeleted) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToUnlinkString(relationTypeName);
          showSnackBar(
            context,
            message: message,
            snackBarAction: dialogSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).moreString,
              title: message,
              content: state.error,
            ),
          );
        }
      },
      child: BlocBuilder<K, ItemRelationState>(
        builder: (BuildContext context, ItemRelationState state) {
          if (state is ItemRelationLoaded<W>) {
            return (isSingleList)
                ? _RelationListSingle<W>(
                    items: state.otherItems,
                    relationName: relationName,
                    relationTypeName: relationTypeName,
                    itemBuilder: cardBuilder,
                    onSearch: _onRepositorySearchTap(context),
                    updateAdd: _addRelationFunction(context),
                    updateDelete: _deleteRelationFunction(context),
                  )
                : _RelationListMany<W>(
                    items: state.otherItems,
                    relationName: relationName,
                    relationTypeName: relationTypeName,
                    itemBuilder: cardBuilder,
                    onSearch: _onRepositorySearchTap(context),
                    updateAdd: _addRelationFunction(context),
                    updateDelete: _deleteRelationFunction(context),
                    trailingBuilder: trailingBuilder,
                    limitHeight: limitHeight,
                  );
          }
          if (state is ItemRelationNotLoaded) {
            return Center(
              child: Text(state.error),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: Column(
                  children: <Widget>[
                    HeaderText(
                      text: relationName,
                    ),
                    Container(
                      constraints: limitHeight
                          ? BoxConstraints.loose(
                              Size.fromHeight(
                                (MediaQuery.of(context).size.height / 3),
                              ),
                            )
                          : null,
                      child: SkeletonItemList(
                        single: isSingleList,
                        canBeDragged: true,
                        itemHasImage: hasImage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void Function(W) _addRelationFunction(BuildContext context) {
    return (W addedItem) {
      BlocProvider.of<S>(context).add(
        AddItemRelation<W>(
          addedItem,
        ),
      );
    };
  }

  void Function(W) _deleteRelationFunction(BuildContext context) {
    return (W deletedItem) {
      BlocProvider.of<S>(context).add(
        DeleteItemRelation<W>(
          deletedItem,
        ),
      );
    };
  }

  Future<W?> Function() _onRepositorySearchTap(BuildContext context) {
    return () {
      return Navigator.pushNamed<W>(
        context,
        searchRouteName,
        arguments: const SearchArguments(
          onTapReturn: true,
        ),
      );
    };
  }

  @nonVirtual
  void Function()? onTap(BuildContext context, W item) {
    return detailRouteName.isNotEmpty
        ? () async {
            Navigator.pushNamed(
              context,
              detailRouteName,
              arguments: DetailArguments<W>(
                item: item,
                onChange: () {
                  // Reload list if changes were made
                  BlocProvider.of<K>(context).add(ReloadItemRelation());
                },
              ),
            );
          }
        : null;
  }

  Widget cardBuilder(BuildContext context, W item);
}

class _RelationList extends StatelessWidget {
  const _RelationList({
    Key? key,
    required this.headerText,
    required this.relationList,
    this.linkWidget,
    this.trailingWidget,
  }) : super(key: key);

  final String headerText;
  final Widget relationList;
  final Widget? linkWidget;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 8.0,
          ),
          child: Column(
            children: <Widget>[
              HeaderText(
                text: headerText,
              ),
              relationList,
              SizedBox(
                width: double.maxFinite,
                child: linkWidget,
              ),
              trailingWidget ?? const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

class _LinkButton<W extends PrimaryModel> extends StatelessWidget {
  const _LinkButton({
    Key? key,
    required this.typeName,
    required this.onSearch,
    required this.updateAdd,
  }) : super(key: key);

  final String typeName;
  final Future<W?> Function() onSearch;
  final void Function(W) updateAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: ElevatedButton.icon(
        label:
            Text(GameCollectionLocalisations.of(context).linkString(typeName)),
        icon: const Icon(Icons.link),
        onPressed: () async {
          onSearch().then((W? result) {
            if (result != null) {
              updateAdd(result);
            }
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor:
              ThemeUtils.isThemeDark(context) ? Colors.white : Colors.black87,
          backgroundColor: ThemeUtils.isThemeDark(context)
              ? Colors.grey[700]
              : Colors.grey[300],
          surfaceTintColor: AppTheme.defaultThemeSurfaceTintColor(context),
        ),
      ),
    );
  }
}

class _RelationListSingle<W extends PrimaryModel> extends StatelessWidget {
  const _RelationListSingle({
    Key? key,
    required this.items,
    required this.relationName,
    required this.relationTypeName,
    required this.itemBuilder,
    required this.onSearch,
    required this.updateAdd,
    required this.updateDelete,
  }) : super(key: key);

  final List<W> items;
  final String relationName;
  final String relationTypeName;
  final Widget Function(BuildContext, W) itemBuilder;
  final Future<W?> Function() onSearch;
  final void Function(W) updateAdd;
  final void Function(W) updateDelete;

  @override
  Widget build(BuildContext context) {
    return _RelationList(
      headerText: relationName,
      relationList: ItemListBuilder(
        canBeDragged: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final W relation = items[index];

          return DismissibleItem(
            dismissibleKey: relation.id.toString(), // TODO Wait for uuid
            itemWidget: itemBuilder(context, relation),
            onDismissed: (DismissDirection direction) {
              updateDelete(relation);
            },
            dismissIcon: Icons.link_off,
          );
        },
      ),
      linkWidget: items.isEmpty
          ? _LinkButton<W>(
              typeName: relationTypeName,
              onSearch: onSearch,
              updateAdd: updateAdd,
            )
          : const SizedBox(),
    );
  }
}

class _RelationListMany<W extends PrimaryModel> extends StatelessWidget {
  const _RelationListMany({
    Key? key,
    required this.items,
    required this.relationName,
    required this.relationTypeName,
    required this.itemBuilder,
    required this.onSearch,
    required this.updateAdd,
    required this.updateDelete,
    this.trailingBuilder,
    this.limitHeight = true,
  }) : super(key: key);

  final List<W> items;
  final String relationName;
  final String relationTypeName;
  final Widget Function(BuildContext, W) itemBuilder;
  final Future<W?> Function() onSearch;
  final void Function(W) updateAdd;
  final void Function(W) updateDelete;
  final List<Widget> Function(List<W>)? trailingBuilder;
  final bool limitHeight;

  @override
  Widget build(BuildContext context) {
    return _RelationList(
      headerText: '$relationName (${items.length})',
      relationList: Container(
        constraints: limitHeight
            ? BoxConstraints.loose(
                Size.fromHeight(
                  (MediaQuery.of(context).size.height / 3),
                ),
              )
            : null,
        child: ItemListBuilder(
          canBeDragged: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final W relation = items[index];

            return DismissibleItem(
              dismissibleKey: relation.id.toString(), // TODO Wait for uuid,
              itemWidget: itemBuilder(context, relation),
              onDismissed: (DismissDirection direction) {
                updateDelete(relation);
              },
              dismissIcon: Icons.link_off,
            );
          },
        ),
      ),
      linkWidget: _LinkButton<W>(
        typeName: relationTypeName,
        onSearch: onSearch,
        updateAdd: updateAdd,
      ),
      trailingWidget: trailingBuilder != null
          ? Column(
              children: trailingBuilder!(items),
            )
          : const SizedBox(),
    );
  }
}
