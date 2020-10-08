import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../common/item_view.dart';
import '../common/loading_icon.dart';
import '../common/show_snackbar.dart';
import '../detail/detail.dart';


abstract class ItemAppBar<T extends CollectionItem, K extends ItemListBloc<T>> extends _ItemListMember with PreferredSizeWidget {

  @override
  final Size preferredSize = Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(barData.title + 's'),
      backgroundColor: barData.color,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.sort_by_alpha),
          tooltip: 'Change Order',
          onPressed: () {
            BlocProvider.of<K>(context).add(UpdateSortOrder());
          },
        ),
        IconButton(
          icon: Icon(Icons.grid_on),
          tooltip: 'Change Style',
          onPressed: () {
            BlocProvider.of<K>(context).add(UpdateStyle());
          },
        ),
        viewActionBuilder(
          barData: barData,
          onSelect: (int selectedViewIndex) {
            BlocProvider.of<K>(context).add(UpdateView(selectedViewIndex));
          },
        ),
      ],
    );

  }

  Widget viewActionBuilder({BarData barData, void Function(int) onSelect}) {

    return PopupMenuButton<int>(
      icon: Icon(Icons.view_carousel),
      tooltip: "Change View",
      itemBuilder: (BuildContext context) {
        return barData.views.map( (String view) {
          return PopupMenuItem<int>(
            child: ListTile(
              title: Text(view),
            ),
            value: barData.views.indexOf(view),
          );
        }).toList(growable: false);
      },
      onSelected: onSelect,
    );

  }

}

abstract class ItemFAB<T extends CollectionItem, S extends ItemListManagerBloc<T>> extends _ItemListMember {

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      onPressed: () {
        BlocProvider.of<S>(context).add(AddItem());
      },
      tooltip: 'New ' + barData.title,
      child: Icon(Icons.add),
      backgroundColor: barData.color,
    );

  }

}

abstract class _ItemListMember extends StatelessWidget {

  BarData barData;

}

abstract class ItemList<T extends CollectionItem, K extends ItemListBloc<T>, S extends ItemListManagerBloc<T>> extends StatelessWidget {

  String _typeName = T.toString();

  String detailRouteName;

  @override
  Widget build(BuildContext context) {

    return BlocListener<S, ItemListManagerState>(
      listener: (BuildContext context, ItemListManagerState state) {
        if(state is ItemAdded<T>) {
          String message = "Added " + _typeName;
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
            seconds: 2,
            snackBarAction: SnackBarAction(
              label: "Open",
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  detailRouteName,
                  arguments: DetailArguments(
                    item: state.item,
                  )
                );
              },
            ),
          );
        }
        if(state is ItemNotAdded) {
          String message = "Unable to add " + _typeName;
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
            seconds: 2,
            snackBarAction: dialogSnackBarAction(
              context,
              label: "More",
              title: message,
              content: state.error,
            ),
          );
        }
        if(state is ItemDeleted<T>) {
          String message = "Deleted " + _typeName;
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
            seconds: 2,
          );
        }
        if(state is ItemNotDeleted) {
          String message = "Unable to delete " + _typeName;
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
            seconds: 2,
            snackBarAction: dialogSnackBarAction(
              context,
              label: "More",
              title: message,
              content: state.error,
            ),
          );
        }
      },
      child: BlocBuilder<K, ItemListState>(
        builder: (BuildContext context, ItemListState state) {

          if(state is ItemListLoaded<T>) {

            return itemListBodyBuilder(
              items: state.items,
              viewIndex: state.viewIndex,
              onDelete: (T item) {
                BlocProvider.of<S>(context).add(DeleteItem<T>(item));
              },
              style: state.style,
            );

          }
          if(state is ItemListNotLoaded) {

            return Center(
              child: Text(state.error),
            );

          }

          return LoadingIcon();

        },
      ),
    );

  }

  external ItemListBody<T, K> itemListBodyBuilder({@required List<T> items, @required int viewIndex, @required void Function(T) onDelete, @required ListStyle style});

}

abstract class ItemListBody<T extends CollectionItem, K extends ItemListBloc<T>> extends StatelessWidget {
  ItemListBody({Key key, @required this.items, @required this.viewIndex, @required this.onDelete, @required this.style}) : super(key: key);

  final List<T> items;
  final int viewIndex;
  final void Function(T) onDelete;
  final ListStyle style;

  String detailRouteName;
  String localSearchRouteName;
  String statisticsRouteName;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
            title: Text(getViewTitle()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  tooltip: 'Search in View',
                  onPressed: items.isNotEmpty? _onSearchTap(context) : null,
                ),
                /*IconButton(
                  icon: Icon(Icons.insert_chart),
                  tooltip: 'Stats in View',
                  onPressed: items.isNotEmpty? onStatisticsTap(context) : null,
                ),*/
              ],
            ),
          ),
          color: Colors.grey,
        ),
        Expanded(
          child: Scrollbar(
            child: _listBuilder(context),
          ),
        ),
      ],
    );

  }

  Widget _confirmDelete(BuildContext context, T item) {

    return AlertDialog(
      title: Text("Delete"),
      content: ListTile(
        title: Text("Are you sure you want to delete " + item.getTitle() + "?"),
        subtitle: Text("This action cannot be undone"),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.maybePop<bool>(context);
          },
        ),
        RaisedButton(
          child: Text("Delete", style: TextStyle(color: Colors.white),),
          onPressed: () {
            Navigator.maybePop<bool>(context, true);
          },
          color: Colors.red,
        )
      ],
    );

  }

  Widget _listBuilder(BuildContext context) {

    switch(style) {
      case ListStyle.Card:
        return ItemCardView<T>(
          items: items,
          itemBuilder: cardBuilder,
          onDismiss: onDelete,
          confirmDelete: _confirmDelete,
        );
      case ListStyle.Grid:
        return ItemGridView<T>(
          items: items,
          itemBuilder: gridBuilder,
        );
    }

    return Container();

  }

  void Function() _onTap(BuildContext context, T item) {

    return () {
      Navigator.pushNamed(
        context,
        detailRouteName,
        arguments: DetailArguments(
          item: item,
          onUpdate: (T updatedItem) {

            if(updatedItem != null) {

              BlocProvider.of<K>(context).add(UpdateListItem<T>(updatedItem));

            }

          },
        ),
      );
    };

  }

  void Function() _onSearchTap(BuildContext context) {

    return () {
      Navigator.pushNamed(
        context,
        localSearchRouteName,
        arguments: items,
      );
    };

  }

  void Function() onStatisticsTap(BuildContext context) {

    return () {
      Navigator.pushNamed(
        context,
        statisticsRouteName,
        arguments: items,
      );
    };

  }

  Widget cardBuilder(BuildContext context, T item) {

    return ItemCard(
      title: item.getTitle(),
      subtitle: item.getSubtitle(),
      imageURL: item.getImageURL(),
      onTap: _onTap(context, item),
    );

  }

  Widget gridBuilder(BuildContext context, T item) {

    return ItemGrid(
      title: item.getTitle(),
      imageURL: item.getImageURL(),
      onTap: _onTap(context, item),
    );

  }

  external String getViewTitle();

}

class ItemCardView<T extends CollectionItem> extends StatelessWidget {
  const ItemCardView({Key key, @required this.items, @required this.itemBuilder, @required this.onDismiss, @required this.confirmDelete}) : super(key: key);

  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T item) onDismiss;
  final Widget Function(BuildContext, T) confirmDelete;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        T item = items[index];

        return DismissibleItem(
          dismissibleKey: item.ID,
          itemWidget: itemBuilder(context, item),
          onDismissed: (DismissDirection direction) {
            onDismiss(item);
          },
          confirmDismiss: (DismissDirection direction) {

            return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return confirmDelete(context, item);
              },
            );

          },
          dismissIcon: Icons.delete,
        );

      },
    );

  }
}

class ItemGridView<T extends CollectionItem> extends StatelessWidget {
  const ItemGridView({Key key, @required this.items, @required this.itemBuilder}) : super(key: key);

  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        T item = items[index];

        return itemBuilder(context, item);

      },
    );

  }
}

class TabsDelegate extends SliverPersistentHeaderDelegate {
  TabsDelegate({@required this.tabBar, this.color}) : super();

  final TabBar tabBar;
  final Color color;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      color: color?? Theme.of(context).primaryColor,
      child: tabBar,
    );

  }

  @override
  bool shouldRebuild(TabsDelegate oldDelegate) {
    return false;
  }
}