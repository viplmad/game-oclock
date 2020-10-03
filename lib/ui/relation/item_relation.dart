import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';

import 'package:game_collection/model/model.dart';

import '../common/show_snackbar.dart';
import '../common/item_view.dart';
import '../search/search.dart';
import '../detail/detail.dart';

abstract class ItemRelationList<T extends CollectionItem, W extends CollectionItem, K extends ItemRelationBloc<T, W>> extends StatelessWidget {
  ItemRelationList({Key key, this.shownName, this.trailingBuilder}) : super(key: key);

  bool isSingleList = false;
  String typeName = W.toString();
  final String shownName;
  final List<Widget> Function(List<W>) trailingBuilder;

  @override
  Widget build(BuildContext context) {

    return BlocListener<K, ItemRelationState>(
      listener: (BuildContext context, ItemRelationState state) {
        if(state is ItemRelationAdded<W>) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Linked",
            snackBarAction: SnackBarAction(
              label: 'Undo',
              onPressed: () {

                BlocProvider.of<K>(context).add(
                  DeleteItemRelation<W>(
                    state.otherItem,
                  ),
                );

              },
            ),
          );
        }
        if(state is ItemRelationNotAdded) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unable to link",
            snackBarAction: dialogSnackBarAction(
              context,
              label: "More",
              title: "Unable to link",
              content: state.error,
            ),
          );
        }
        if(state is ItemRelationDeleted<W>) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unlinked",
            snackBarAction: SnackBarAction(
              label: 'Undo',
              onPressed: () {

                BlocProvider.of<K>(context).add(
                  AddItemRelation<W>(
                    state.otherItem,
                  ),
                );

              },
            ),
          );
        }
        if(state is ItemRelationNotDeleted) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unable to unlink",
            snackBarAction: dialogSnackBarAction(
              context,
              label: "More",
              title: "Unable to unlink",
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
                shownName: shownName?? typeName,
                linkName: typeName,
                itemBuilder: cardBuilder,
                onSearch: _repositorySearchFuture(context),
                updateAdd: _addRelationFunction(context),
                updateDelete: _deleteRelationFunction(context),
              )
              :
              _ResultsListMany<W>(
                items: state.otherItems,
                shownName: shownName?? typeName + 's',
                linkName: typeName,
                itemBuilder: cardBuilder,
                onSearch: _repositorySearchFuture(context),
                updateAdd: _addRelationFunction(context),
                updateDelete: _deleteRelationFunction(context),
                trailingBuilder: trailingBuilder,
                onListSearch: state.otherItems.isNotEmpty? _localSearchFuture(context, state.otherItems) : null,
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
      BlocProvider.of<K>(context).add(
        AddItemRelation<W>(
          addedItem,
        ),
      );
    };

  }

  void Function(W) _deleteRelationFunction(BuildContext context) {

    return (W deletedItem) {
      BlocProvider.of<K>(context).add(
        DeleteItemRelation<W>(
          deletedItem,
        ),
      );
    };

  }

  void Function() onTap(BuildContext context, W item) {

    return () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return detailBuilder(item);
          }
        ),
      );
    };

  }

  Future<W> Function() _repositorySearchFuture(BuildContext context) {

    return () {
      return Navigator.push<W>(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              return repositorySearchBuilder(context);
            }
        ),
      );
    };

  }

  Widget _localSearchBuilder(BuildContext context, List<W> items) {

    return ItemLocalSearch<W>(
      items: items,
      onTap: (BuildContext context, W result) {
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return detailBuilder(result);
              },
            ),
          );
        };
      },
    );

  }

  void Function() _localSearchFuture(BuildContext context, List<W> items) {

    return () {
      return Navigator.push<W>(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              return _localSearchBuilder(context, items);
            }
        ),
      );
    };

  }

  Widget cardBuilder(BuildContext context, W item) {

    return ItemListCard(
      title: item.getTitle(),
      subtitle: item.getSubtitle(),
      imageURL: item.getImageURL(),
      onTap: onTap(context, item),
    );

  }

  external ItemDetail<W, ItemDetailBloc<W>> detailBuilder(W item);
  external ItemSearch<W, ItemSearchBloc<W>> repositorySearchBuilder(BuildContext context);

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
                    tooltip: "Seach in List",
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

  const _LinkButton({Key key, this.itemTypeName, @required this.onSearch, @required this.updateAdd}) : super(key: key);

  final String itemTypeName;
  final Future<W> Function() onSearch;
  final void Function(W) updateAdd;

  String get shownName => itemTypeName?? W.toString();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: RaisedButton.icon(
        label: Text("Link " + shownName),
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
  _ResultsListSingle({@required this.items, this.shownName, this.linkName, @required this.itemBuilder, @required this.onSearch, @required this.updateAdd, @required this.updateDelete});

  final List<W> items;
  final String shownName;
  final String linkName;
  final Widget Function(BuildContext, W) itemBuilder;
  final Future<W> Function() onSearch;
  final void Function(W) updateAdd;
  final void Function(W) updateDelete;

  @override
  Widget build(BuildContext context) {

    return _ResultsList(
      headerText: shownName,
      resultList: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          W result = items[index];

          return DismissibleItem(
            dismissibleKey: result.ID,
            itemWidget: itemBuilder(context, result),
            onDismissed: (DismissDirection direction) {
              updateDelete(result);
            },
            dismissIcon: Icons.link_off,
          );

        },
      ),
      linkWidget: items.isEmpty? _LinkButton<W>(
        itemTypeName: linkName,
        onSearch: onSearch,
        updateAdd: updateAdd,
      ) : null,
    );

  }

}
class _ResultsListMany<W extends CollectionItem> extends StatelessWidget {
  _ResultsListMany({@required this.items, this.shownName, this.linkName, @required this.itemBuilder, @required this.onSearch, @required this.updateAdd, @required this.updateDelete, this.trailingBuilder, this.onListSearch});

  final List<W> items;
  final String shownName;
  final String linkName;
  final Widget Function(BuildContext, W) itemBuilder;
  final Future<W> Function() onSearch;
  final void Function(W) updateAdd;
  final void Function(W) updateDelete;
  final List<Widget> Function(List<W>) trailingBuilder;
  final void Function() onListSearch;

  @override
  Widget build(BuildContext context) {

    return _ResultsList(
      headerText: shownName + " (" + items.length.toString() + ")",
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
                dismissibleKey: result.ID,
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
        itemTypeName: linkName,
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