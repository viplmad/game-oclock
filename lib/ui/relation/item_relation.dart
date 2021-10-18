import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';
import '../common/item_view.dart';
import '../detail/detail.dart';


abstract class ItemRelationList<T extends Item, W extends Item, K extends Bloc<ItemRelationEvent, ItemRelationState>, S extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState>> extends StatelessWidget {
  const ItemRelationList({
    Key? key,
    required this.relationName,
    required this.relationTypeName,
    this.trailingBuilder,
    this.limitHeight = true,
    this.isSingleList = false,
    this.detailRouteName = '',
    this.searchRouteName = '',
    this.localSearchRouteName = '',
  }) : super(key: key);

  final String relationName;
  final String relationTypeName;
  final List<Widget> Function(List<W>)? trailingBuilder;
  final bool limitHeight;
  final bool isSingleList;

  final String detailRouteName;
  final String searchRouteName;
  final String localSearchRouteName;

  @override
  Widget build(BuildContext context) {

    return BlocListener<S, ItemRelationManagerState>(
      listener: (BuildContext context, ItemRelationManagerState state) {
        if(state is ItemRelationAdded<W>) {
          final String message = GameCollectionLocalisations.of(context).linkedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
            snackBarAction: SnackBarAction(
              label: GameCollectionLocalisations.of(context).undoString,
              onPressed: () {

                BlocProvider.of<S>(context).add(
                  DeleteItemRelation<W>(
                    state.otherItem,
                  ),
                );

              },
            ),
          );
        }
        if(state is ItemRelationNotAdded) {
          final String message = GameCollectionLocalisations.of(context).unableToLinkString(relationTypeName);
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
        if(state is ItemRelationDeleted<W>) {
          final String message = GameCollectionLocalisations.of(context).unlinkedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
            snackBarAction: SnackBarAction(
              label: GameCollectionLocalisations.of(context).undoString,
              onPressed: () {

                BlocProvider.of<S>(context).add(
                  AddItemRelation<W>(
                    state.otherItem,
                  ),
                );

              },
            ),
          );
        }
        if(state is ItemRelationNotDeleted) {
          final String message = GameCollectionLocalisations.of(context).unableToUnlinkString(relationTypeName);
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

          if(state is ItemRelationLoaded<W>) {

            return (isSingleList)?
              _ResultsListSingle<W>(
                items: state.otherItems,
                relationName: relationName,
                relationTypeName: relationTypeName,
                itemBuilder: cardBuilder,
                onSearch: _onRepositorySearchTap(context),
                updateAdd: _addRelationFunction(context),
                updateDelete: _deleteRelationFunction(context),
              )
              :
              _ResultsListMany<W>(
                items: state.otherItems,
                relationName: relationName,
                relationTypeName: relationTypeName,
                itemBuilder: cardBuilder,
                onSearch: _onRepositorySearchTap(context),
                updateAdd: _addRelationFunction(context),
                updateDelete: _deleteRelationFunction(context),
                trailingBuilder: trailingBuilder,
                onListSearch: state.otherItems.isNotEmpty? _onLocalSearchTap(context, state.otherItems) : null,
                limitHeight: limitHeight,
              );

          }

          if(state is ItemRelationNotLoaded) {
            return Center(
              child: Text(state.error),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Divider(),
              LinearProgressIndicator(),
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
      );
    };

  }

  Future<dynamic> Function() _onLocalSearchTap(BuildContext context, List<W> items) {

    return () {
      return Navigator.pushNamed(
        context,
        localSearchRouteName,
        arguments: items,
      );
    };

  }

  void Function()? onTap(BuildContext context, W item) {

    return () {
      Navigator.pushNamed(
        context,
        detailRouteName,
        arguments: DetailArguments<W>(
          item: item,
          onUpdate: (W? updatedItem) {

            if(updatedItem != null) {

              BlocProvider.of<K>(context).add(UpdateRelationItem<W>(updatedItem));

            }

          },
        ),
      );
    };

  }

  Widget cardBuilder(BuildContext context, W item);
}

class _HeaderText extends StatelessWidget {
  const _HeaderText({
    Key? key,
    required this.text,
    this.trailingWidget,
  }) : super(key: key);

  final String text;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(text, style: Theme.of(context).textTheme.subtitle1),
        trailingWidget?? Container(),
      ],
    );

  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    Key? key,
    required this.headerText,
    required this.resultList,
    this.linkWidget,
    this.trailingWidget,
    this.onListSearch,
  }) : super(key: key);

  final String headerText;
  final Widget resultList;
  final Widget? linkWidget;
  final Widget? trailingWidget;
  final void Function()? onListSearch;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: _HeaderText(
                  text: headerText,
                  trailingWidget: onListSearch != null?
                    IconButton(
                      icon: const Icon(Icons.search),
                      tooltip: GameCollectionLocalisations.of(context).searchInListString,
                      onPressed: onListSearch,
                    ) : Container(),
                ),
              ),
              resultList,
              SizedBox(
                width: double.maxFinite,
                child: linkWidget,
              ),
              trailingWidget?? Container(),
            ],
          ),
        ),
      ],
    );

  }
}

class _LinkButton<W extends Item> extends StatelessWidget {
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
        label: Text(GameCollectionLocalisations.of(context).linkString(typeName)),
        icon: const Icon(Icons.link),
        onPressed: () {

          onSearch().then( (W? result) {
            if (result != null) {
              updateAdd(result);
            }
          });

        },
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.black87,
          primary: Colors.grey[300],
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double?>( (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return 2.0;
            }

            return 1.0;
          }),
        ),
      ),
    );

  }
}

class _ResultsListSingle<W extends Item> extends StatelessWidget {
  const _ResultsListSingle({
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

    return _ResultsList(
      headerText: relationName,
      resultList: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final W result = items[index];

          return DismissibleItem(
            dismissibleKey: result.uniqueId,
            itemWidget: itemBuilder(context, result),
            onDismissed: (DismissDirection direction) {
              updateDelete(result);
            },
            dismissIcon: Icons.link_off,
          );

        },
      ),
      linkWidget: items.isEmpty?
        _LinkButton<W>(
          typeName: relationTypeName,
          onSearch: onSearch,
          updateAdd: updateAdd,
        ) : Container(),
    );

  }
}

class _ResultsListMany<W extends Item> extends StatelessWidget {
  const _ResultsListMany({
    Key? key,
    required this.items,
    required this.relationName,
    required this.relationTypeName,
    required this.itemBuilder,
    required this.onSearch,
    required this.updateAdd,
    required this.updateDelete,
    this.trailingBuilder,
    this.onListSearch,
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
  final void Function()? onListSearch;
  final bool limitHeight;

  @override
  Widget build(BuildContext context) {

    return _ResultsList(
      headerText: relationName + ' (' + items.length.toString() + ')',
      resultList: Container(
        constraints: limitHeight? BoxConstraints.loose(
          Size.fromHeight( (MediaQuery.of(context).size.height / 3), ),
        ) : null,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final W result = items[index];

            return DismissibleItem(
              dismissibleKey: result.uniqueId,
              itemWidget: itemBuilder(context, result),
              onDismissed: (DismissDirection direction) {
                updateDelete(result);
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
      trailingWidget: trailingBuilder != null?
        Column(
          children: trailingBuilder!(items),
        ) : Container(),
      onListSearch: onListSearch,
    );

  }
}