import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';
import '../common/item_view.dart';
import '../detail/detail.dart';


abstract class ItemRelationList<T extends CollectionItem, W extends CollectionItem, K extends ItemRelationBloc<T, W>, S extends ItemRelationManagerBloc<T, W>> extends StatelessWidget {
  ItemRelationList({Key key, @required this.relationName, @required this.relationTypeName, this.trailingBuilder}) : super(key: key);

  final String relationName;
  final String relationTypeName;
  final List<Widget> Function(List<W>) trailingBuilder;

  final bool isSingleList = false;

  String get detailRouteName;
  String get searchRouteName;
  String get localSearchRouteName;

  @override
  Widget build(BuildContext context) {

    return BlocListener<S, ItemRelationManagerState>(
      listener: (BuildContext context, ItemRelationManagerState state) {
        if(state is ItemRelationAdded<W>) {
          String message = GameCollectionLocalisations.of(context).linkedString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
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
          String message = GameCollectionLocalisations.of(context).unableToLinkString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
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
          String message = GameCollectionLocalisations.of(context).unlinkedString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
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
          String message = GameCollectionLocalisations.of(context).unableToUnlinkString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
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
                itemBuilder: _cardBuilder,
                onSearch: _onRepositorySearchTap(context),
                updateAdd: _addRelationFunction(context),
                updateDelete: _deleteRelationFunction(context),
              )
              :
              _ResultsListMany<W>(
                items: state.otherItems,
                relationName: relationName,
                relationTypeName: relationTypeName,
                itemBuilder: _cardBuilder,
                onSearch: _onRepositorySearchTap(context),
                updateAdd: _addRelationFunction(context),
                updateDelete: _deleteRelationFunction(context),
                trailingBuilder: trailingBuilder,
                onListSearch: state.otherItems.isNotEmpty? _onLocalSearchTap(context, state.otherItems) : null,
              );

          }

          if(state is ItemRelationNotLoaded) {
            return Center(
              child: Text(state.error),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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

  Future<W> Function() _onRepositorySearchTap(BuildContext context) {

    return () {
      return Navigator.pushNamed<W>(
        context,
        searchRouteName,
      );
    };

  }

  void Function() _onLocalSearchTap(BuildContext context, List<W> items) {

    return () {
      return Navigator.pushNamed(
        context,
        localSearchRouteName,
        arguments: items,
      );
    };

  }

  Widget _cardBuilder(BuildContext context, W item) {

    return ItemCard(
      title: item.getTitle(),
      subtitle: item.getSubtitle(),
      imageURL: item.getImageURL(),
      onTap: onTap(context, item),
    );

  }

  void Function() onTap(BuildContext context, W item) {

    return () {
      Navigator.pushNamed(
        context,
        detailRouteName,
        arguments: DetailArguments(
          item: item,
          onUpdate: (W updatedItem) {

            if(updatedItem != null) {

              BlocProvider.of<K>(context).add(UpdateRelationItem<W>(updatedItem));

            }

          },
        ),
      );
    };

  }

}

class _HeaderText extends StatelessWidget {
  const _HeaderText({Key key, this.text, this.trailingWidget}) : super(key: key);

  final String text;
  final Widget trailingWidget;

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
  const _ResultsList({Key key, @required this.headerText, @required this.resultList, this.linkWidget, this.trailingWidget, this.onListSearch}) : super(key: key);

  final String headerText;
  final Widget resultList;
  final Widget linkWidget;
  final Widget trailingWidget;
  final void Function() onListSearch;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: _HeaderText(
                  text: headerText,
                  trailingWidget: onListSearch != null?
                  IconButton(
                    icon: Icon(Icons.search),
                    tooltip: GameCollectionLocalisations.of(context).searchInListString,
                    onPressed: onListSearch,
                  ) : null,
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

class _LinkButton<W extends CollectionItem> extends StatelessWidget {
  const _LinkButton({Key key, @required this.typeName, @required this.onSearch, @required this.updateAdd}) : super(key: key);

  final String typeName;
  final Future<W> Function() onSearch;
  final void Function(W) updateAdd;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: RaisedButton.icon(
        label: Text(GameCollectionLocalisations.of(context).linkString(typeName)),
        icon: Icon(Icons.link),
        elevation: 1.0,
        highlightElevation: 2.0,
        onPressed: () {

          onSearch().then( (W result) {
            if (result != null) {
              updateAdd(result);
            }
          });

        },
      ),
    );

  }
}

class _ResultsListSingle<W extends CollectionItem> extends StatelessWidget {
  _ResultsListSingle({@required this.items, this.relationName, this.relationTypeName, @required this.itemBuilder, @required this.onSearch, @required this.updateAdd, @required this.updateDelete});

  final List<W> items;
  final String relationName;
  final String relationTypeName;
  final Widget Function(BuildContext, W) itemBuilder;
  final Future<W> Function() onSearch;
  final void Function(W) updateAdd;
  final void Function(W) updateDelete;

  @override
  Widget build(BuildContext context) {

    return _ResultsList(
      headerText: relationName,
      resultList: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          W result = items[index];

          return DismissibleItem(
            dismissibleKey: result.id,
            itemWidget: itemBuilder(context, result),
            onDismissed: (DismissDirection direction) {
              updateDelete(result);
            },
            dismissIcon: Icons.link_off,
          );

        },
      ),
      linkWidget: items.isEmpty? _LinkButton<W>(
        typeName: relationTypeName,
        onSearch: onSearch,
        updateAdd: updateAdd,
      ) : null,
    );

  }

}

class _ResultsListMany<W extends CollectionItem> extends StatelessWidget {
  _ResultsListMany({@required this.items, this.relationName, this.relationTypeName, @required this.itemBuilder, @required this.onSearch, @required this.updateAdd, @required this.updateDelete, this.trailingBuilder, this.onListSearch});

  final List<W> items;
  final String relationName;
  final String relationTypeName;
  final Widget Function(BuildContext, W) itemBuilder;
  final Future<W> Function() onSearch;
  final void Function(W) updateAdd;
  final void Function(W) updateDelete;
  final List<Widget> Function(List<W>) trailingBuilder;
  final void Function() onListSearch;

  @override
  Widget build(BuildContext context) {

    return _ResultsList(
      headerText: relationName + ' (' + items.length.toString() + ')',
      resultList: Container(
        constraints: BoxConstraints.loose(
          Size.fromHeight( (MediaQuery.of(context).size.height / 3), ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            W result = items[index];

            return DismissibleItem(
                dismissibleKey: result.id,
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
        children: trailingBuilder(items),
      ) : null,
      onListSearch: onListSearch,
    );

  }
}